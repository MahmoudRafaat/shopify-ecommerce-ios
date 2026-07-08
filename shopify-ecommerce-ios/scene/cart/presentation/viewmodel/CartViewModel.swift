//
//  CheckoutViewModel.swift
//  shopify-ecommerce-ios
//
//  Created by Ehab Salah on 03/07/2026.
//


import Foundation
import SwiftUI


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
    
    init(useCases: CheckoutUseCases = CheckoutUseCases(
        createDraftOrder: CreateDraftOrderUseCaseImpl(repository: CheckoutRepositoryImpl()),
        getDraftOrder: GetDraftOrderUseCaseImpl(repository: CheckoutRepositoryImpl()),
        getCustomerCartMetafield: GetCustomerCartMetafieldUseCaseImpl(repository: CheckoutRepositoryImpl()),
        setCustomerCartMetafield: SetCustomerCartMetafieldUseCaseImpl(repository: CheckoutRepositoryImpl()),
        updateDraftOrderLineItems: UpdateDraftOrderLineItemsUseCaseImpl(repository: CheckoutRepositoryImpl()),
        applyDiscount: ApplyDiscountUseCaseImpl(repository: CheckoutRepositoryImpl()),
        completeDraftOrder: CompleteDraftOrderUseCaseImpl(repository: CheckoutRepositoryImpl()),
        updateDraftOrderAddress: UpdateDraftOrderAddressUseCaseImpl(repository: CheckoutRepositoryImpl()),
        removeLineItem: RemoveLineItemUseCaseImpl(repository: CheckoutRepositoryImpl()),
        deleteDraftOrder: DeleteDraftOrderUseCaseImpl(repository: CheckoutRepositoryImpl()),
        fetchActiveDiscountCodes: FetchActiveDiscountCodesUseCaseImpl(repository: CheckoutRepositoryImpl()),
        removeDiscount: RemoveDiscountUseCaseImpl(repository: CheckoutRepositoryImpl())
    )) {
        self.useCases = useCases
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

    /// Clears all local and remote cart state after a successful order.
    /// Called by `PaymentViewModel.checkout()` on order completion.
    @MainActor
    func clearCart() async {
        // Reset the customer's cart metafield so a fresh cart is created next time.
        try? await useCases.setCustomerCartMetafield.execute(draftOrderId: 0)
        cartLineItems = []
        draftOrderId  = nil
        orderTotal    = "0.00"
        subtotal      = "0.00"
        originalSubtotal = "0.00"
        tax           = "0.00"
        discountAmount = "0.00"
        selectedCoupon = nil
        selectedCouponCode = nil
        CartService.shared.clear()
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
