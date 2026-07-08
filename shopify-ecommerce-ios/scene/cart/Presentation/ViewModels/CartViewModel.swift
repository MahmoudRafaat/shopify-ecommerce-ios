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
    
    // MARK: - State
    var isLoading = false
    var errorMessage: String?
    
    var draftOrderId: Int?
    var orderTotal: String = "0.00"
    var subtotal: String = "0.00"
    var originalSubtotal: String = "0.00"
    var tax: String = "0.00"
    var discountAmount: String = "0.00"
    
    var cartLineItems: [OrderItemUIModel] = []
    var discountCode: String = ""
    var currentAddress: DraftAddressRequest? = nil
    var isAddressSheetPresented: Bool = false
    var isOrderDeleted: Bool = false
    
    var activeCoupons: [String: PriceRuleResponse] = [:]
    var isCouponSheetPresented: Bool = false
    var selectedCoupon: PriceRuleResponse?
    var selectedCouponCode: String?
    
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
        self.isLoading = true
        self.errorMessage = nil
        
        do {
            async let fetchCouponsTask = useCases.fetchActiveDiscountCodes.execute()
            
            let coupons = try await fetchCouponsTask
            self.activeCoupons = coupons
            
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
                    
                    self.isLoading = false
                    return
                } catch {
                    // Fall through to create a new cart
                }
            }
            
            if products.isEmpty {
                self.isLoading = false
                return
            }
            
            // Create a new draft order
            let draftOrderResponse = try await useCases.createDraftOrder.execute(products: products)
            try await useCases.setCustomerCartMetafield.execute(draftOrderId: draftOrderResponse.id)
            updateUI(with: draftOrderResponse)
            
        } catch {
            self.errorMessage = error.localizedDescription
        }
        self.isLoading = false
    }
    
    @MainActor
    func updateQuantity(for variantId: Int, to newQuantity: Int) async {
        guard let orderId = draftOrderId else { return }
        self.isLoading = true
        self.errorMessage = nil
        
        if let index = cartLineItems.firstIndex(where: { $0.id == variantId }) {
            let existingItem = cartLineItems[index]
            
            let updatedModel = OrderItemUIModel(
                id: existingItem.id,
                title: existingItem.title,
                variantTitle: existingItem.variantTitle,
                price: existingItem.price,
                quantity: newQuantity,
                imageUrl: existingItem.imageUrl
            )
            
            var allItems = cartLineItems
            allItems[index] = updatedModel
            
            do {
                let response = try await useCases.updateDraftOrderLineItems.execute(
                    draftOrderId: orderId,
                    lineItems: allItems
                )
                updateUI(with: response)
            } catch {
                self.errorMessage = error.localizedDescription
            }
        }
        self.isLoading = false
    }
    
    
    @MainActor
    func applyDiscount() async {
        guard let orderId = draftOrderId,
              let code = selectedCouponCode,
              let rule = selectedCoupon else { return }
        
        self.isLoading = true
        self.errorMessage = nil
        
        do {
            let response = try await useCases.applyDiscount.execute(
                draftOrderId: orderId,
                discountCode: code,
                priceRule: rule
            )
            updateUI(with: response)
        } catch {
            self.errorMessage = error.localizedDescription
        }
        self.isLoading = false
    }
    
    @MainActor
    func removeDiscount() async {
        guard let orderId = draftOrderId else { return }
        
        self.isLoading = true
        self.errorMessage = nil
        
        do {
            let response = try await useCases.removeDiscount.execute(draftOrderId: orderId)
            updateUI(with: response)
        } catch {
            self.errorMessage = error.localizedDescription
        }
        
        self.isLoading = false
    }
    
    @MainActor
    func updateAddress(address: DraftAddressRequest) async {
        guard let orderId = draftOrderId else { return }
        self.isLoading = true
        self.errorMessage = nil
        
        do {
            let response = try await useCases.updateDraftOrderAddress.execute(
                draftOrderId: orderId,
                address: address
            )
            self.currentAddress = address
            updateUI(with: response)
        } catch {
            self.errorMessage = error.localizedDescription
        }
        
        self.isLoading = false
    }
    
    @MainActor
    func removeLineItem(variantId: Int) async {
        guard let orderId = draftOrderId else { return }
        self.isLoading = true
        self.errorMessage = nil
        
        let remainingItems = cartLineItems.filter { $0.id != variantId }
        
        do {
            if remainingItems.isEmpty {
                // Last item removed — delete the entire draft order
                try await useCases.deleteDraftOrder.execute(draftOrderId: orderId)
                try await useCases.setCustomerCartMetafield.execute(draftOrderId: 0)
                cartLineItems = []
                draftOrderId = nil
                orderTotal = "0.00"
                subtotal = "0.00"
                originalSubtotal = "0.00"
                tax = "0.00"
                discountAmount = "0.00"
                isOrderDeleted = true
            } else {
                let response = try await useCases.removeLineItem.execute(
                    draftOrderId: orderId,
                    variantId: variantId,
                    currentLineItems: remainingItems
                )
                cartLineItems = remainingItems
                updateUI(with: response)
            }
        } catch {
            self.errorMessage = error.localizedDescription
        }
        
        self.isLoading = false
    }
    
    // MARK: - Cart lifecycle

    /// Clears all local and remote cart state.
    /// Triggered globally via `CartService.shared.clearCartSubject`.
    @MainActor
    func clearCart() async {
        self.isLoading = true
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
            self.errorMessage = "We couldn't finalize the cart reset on the server. Please try refreshing."
        }
        
        // Reset local state
        cartLineItems = []
        draftOrderId  = nil
        orderTotal    = "0.00"
        subtotal      = "0.00"
        originalSubtotal = "0.00"
        tax           = "0.00"
        discountAmount = "0.00"
        selectedCoupon = nil
        selectedCouponCode = nil
        
        self.isLoading = false
    }
    private func updateUI(with response: CheckoutOrderInfo) {
        self.draftOrderId = response.id
        self.subtotal = response.subtotal
        self.tax = response.tax
        self.orderTotal = response.total
        self.originalSubtotal = response.originalSubtotal
        self.discountAmount = response.discountAmount
        self.cartLineItems = response.lineItems
        
        let syncedProducts = response.lineItems.map { uiItem in
            ProductDataModel(variantId: uiItem.id, quantity: uiItem.quantity, imageUrl: uiItem.imageUrl)
        }
        CartService.shared.sync(products: syncedProducts)
    }
}
