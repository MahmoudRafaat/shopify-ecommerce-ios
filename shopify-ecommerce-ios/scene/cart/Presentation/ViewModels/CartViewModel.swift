//
//  CheckoutViewModel.swift
//  shopify-ecommerce-ios
//
//  Created by Ehab Salah on 03/07/2026.
//


import Foundation
import SwiftUI
import Combine




@Observable
final class CartViewModel: CartViewModelProtocol {
    
    private let useCases: CheckoutUseCases
    
    var uiState = CartUIState()
    
    private var cancellables = Set<AnyCancellable>()
    
    init(useCases: CheckoutUseCases) {
        self.useCases = useCases
        
        CartService.shared.clearCartSubject
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                Task {
                    await self?.clearCart()
                }
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Intentions
    
    @MainActor
    func loadOrCreateCart(products: [ProductDataModel]) async {
        self.uiState.isLoading = true
        self.uiState.error = nil
        
        do {
            async let fetchCouponsTask = useCases.fetchActiveDiscountCodes.execute()
            
            let coupons = try await fetchCouponsTask
            self.uiState.activeCoupons = coupons
            
            if let cartMetafield = try await useCases.getCustomerCartMetafield.execute(),
               let savedCartId = Int?(cartMetafield.value), savedCartId > 0 {
                do {
                    let draftOrderResponse = try await useCases.getDraftOrder.execute(draftOrderId: savedCartId)
                    // If order is completed, we should create a new one
                    if draftOrderResponse.status == "completed" {
                        throw NSError(domain: "CartCompleted", code: 400, userInfo: nil)
                    }
                    
                    let existingVariantIds = Set(draftOrderResponse.lineItems.map { $0.id })
                    let newProducts = products.filter { !existingVariantIds.contains($0.variantId) }
                    
                    if !newProducts.isEmpty {
                        var combinedUIItems = draftOrderResponse.lineItems
                        for product in newProducts {
                            let dummyUIItem = OrderItemUIModel(
                                id: product.variantId,
                                title: "",
                                variantTitle: "",
                                price: "0",
                                quantity: product.quantity,
                                imageUrl: product.imageUrl
                            )
                            combinedUIItems.append(dummyUIItem)
                        }
                        
                        let updatedResponse = try await useCases.updateDraftOrderLineItems.execute(draftOrderId: draftOrderResponse.id, lineItems: combinedUIItems)
                        updateUI(with: updatedResponse)
                    } else {
                        updateUI(with: draftOrderResponse)
                    }
                    
                    self.uiState.isLoading = false
                    return
                } catch {
                    // Fall through to create a new cart
                }
            }
            
            if products.isEmpty {
                self.uiState.isLoading = false
                return
            }
            
            // Create a new draft order
            let draftOrderResponse = try await useCases.createDraftOrder.execute(products: products)
            try await useCases.setCustomerCartMetafield.execute(draftOrderId: draftOrderResponse.id)
            updateUI(with: draftOrderResponse)
            
        } catch {
            self.uiState.error = AppError.determine()
        }
        self.uiState.isLoading = false
    }
    
    @MainActor
    func updateQuantity(for variantId: Int, to newQuantity: Int) async {
        guard let orderId = uiState.draftOrderId else { return }
        self.uiState.isLoading = true
        self.uiState.error = nil
        
        if let index = uiState.cartLineItems.firstIndex(where: { $0.id == variantId }) {
            let existingItem = uiState.cartLineItems[index]
            
            let updatedModel = OrderItemUIModel(
                id: existingItem.id,
                title: existingItem.title,
                variantTitle: existingItem.variantTitle,
                price: existingItem.price,
                quantity: newQuantity,
                imageUrl: existingItem.imageUrl
            )
            
            var allItems = uiState.cartLineItems
            allItems[index] = updatedModel
            
            do {
                let response = try await useCases.updateDraftOrderLineItems.execute(
                    draftOrderId: orderId,
                    lineItems: allItems
                )
                updateUI(with: response)
            } catch {
                self.uiState.error = AppError.determine()
            }
        }
        self.uiState.isLoading = false
    }
    
    
    @MainActor
    func applyDiscount() async {
        guard let orderId = uiState.draftOrderId,
              let code = uiState.selectedCouponCode,
              let rule = uiState.selectedCoupon else { return }
        
        self.uiState.isLoading = true
        self.uiState.error = nil
        
        do {
            let response = try await useCases.applyDiscount.execute(
                draftOrderId: orderId,
                discountCode: code,
                priceRule: rule
            )
            updateUI(with: response)
        } catch {
            self.uiState.error = AppError.determine()
        }
        self.uiState.isLoading = false
    }
    
    @MainActor
    func removeDiscount() async {
        guard let orderId = uiState.draftOrderId else { return }
        
        self.uiState.isLoading = true
        self.uiState.error = nil
        
        do {
            let response = try await useCases.removeDiscount.execute(draftOrderId: orderId)
            updateUI(with: response)
        } catch {
            self.uiState.error = AppError.determine()
        }
        
        self.uiState.isLoading = false
    }
    
    @MainActor
    func updateAddress(address: DraftAddressRequest) async {
        guard let orderId = uiState.draftOrderId else { return }
        self.uiState.isLoading = true
        self.uiState.error = nil
        
        do {
            let response = try await useCases.updateDraftOrderAddress.execute(
                draftOrderId: orderId,
                address: address
            )
            self.uiState.currentAddress = address
            updateUI(with: response)
        } catch {
            self.uiState.error = AppError.determine()
        }
        
        self.uiState.isLoading = false
    }
    
    @MainActor
    func removeLineItem(variantId: Int) async {
        guard let orderId = uiState.draftOrderId else { return }
        self.uiState.isLoading = true
        self.uiState.error = nil
        
        let remainingItems = uiState.cartLineItems.filter { $0.id != variantId }
        
        do {
            if remainingItems.isEmpty {
                // Last item removed — delete the entire draft order
                try await useCases.deleteDraftOrder.execute(draftOrderId: orderId)
                try await useCases.setCustomerCartMetafield.execute(draftOrderId: 0)
                uiState.cartLineItems = []
                uiState.draftOrderId = nil
                uiState.orderTotal = "0.00"
                uiState.subtotal = "0.00"
                uiState.originalSubtotal = "0.00"
                uiState.tax = "0.00"
                uiState.discountAmount = "0.00"
                uiState.isOrderDeleted = true
            } else {
                let response = try await useCases.removeLineItem.execute(
                    draftOrderId: orderId,
                    variantId: variantId,
                    currentLineItems: remainingItems
                )
                uiState.cartLineItems = remainingItems
                updateUI(with: response)
            }
        } catch {
            self.uiState.error = AppError.determine()
        }
        
        self.uiState.isLoading = false
    }
    
    // MARK: - Cart lifecycle

    /// Clears all local and remote cart state.
    /// Triggered globally via `CartService.shared.clearCartSubject`.
    @MainActor
    func clearCart() async {
        self.uiState.isLoading = true
        var resetSuccess = false
        
        // Robust retry mechanism for Metafield reset (up to 3 retries)
        for attempt in 1...3 {
            do {
                try await useCases.setCustomerCartMetafield.execute(draftOrderId: 0)
                resetSuccess = true
                break
            } catch {
                print("[CartViewModel] Failed to reset cart metafield (Attempt \(attempt)): \(error)")
                if attempt < 3 {
                    try? await Task.sleep(nanoseconds: 1_000_000_000) // wait 1s before retry
                }
            }
        }
        
        if !resetSuccess {
            self.uiState.error = AppError.determine()
        }
        
        // Reset local state
        uiState.cartLineItems = []
        uiState.draftOrderId  = nil
        uiState.orderTotal    = "0.00"
        uiState.subtotal      = "0.00"
        uiState.originalSubtotal = "0.00"
        uiState.tax           = "0.00"
        uiState.discountAmount = "0.00"
        uiState.selectedCoupon = nil
        uiState.selectedCouponCode = nil
        
        self.uiState.isLoading = false
    }
    private func updateUI(with response: CheckoutOrderInfo) {
        self.uiState.draftOrderId = response.id
        self.uiState.subtotal = response.subtotal
        self.uiState.tax = response.tax
        self.uiState.orderTotal = response.total
        self.uiState.originalSubtotal = response.originalSubtotal
        self.uiState.discountAmount = response.discountAmount
        self.uiState.cartLineItems = response.lineItems
        
        let syncedProducts = response.lineItems.map { uiItem in
            ProductDataModel(variantId: uiItem.id, quantity: uiItem.quantity, imageUrl: uiItem.imageUrl)
        }
        CartService.shared.sync(products: syncedProducts)
    }
}
