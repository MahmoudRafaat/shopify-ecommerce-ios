//
//  CheckoutViewModel.swift
//  shopify-ecommerce-ios
//
//  Created by Ehab Salah on 03/07/2026.
//


import Foundation
import SwiftUI


@Observable
final class CheckoutViewModel: CheckoutViewModelProtocol {
    
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
    
    var cartLineItems: [DraftLineItemRequest] = []
    var discountCode: String = ""
    var currentAddress: DraftAddressRequest? = nil
    var isAddressSheetPresented: Bool = false
    var isOrderDeleted: Bool = false
    
    // Coupons state
    var activeCoupons: [String: PriceRuleResponse] = [:]
    var isCouponSheetPresented: Bool = false
    var selectedCoupon: PriceRuleResponse?
    var selectedCouponCode: String?
    
    init(useCases: CheckoutUseCases = CheckoutUseCases(
        createDraftOrder: CreateDraftOrderUseCaseImpl(repository: CheckoutRepositoryImpl()),
        updateDraftOrderLineItems: UpdateDraftOrderLineItemsUseCaseImpl(repository: CheckoutRepositoryImpl()),
        applyDiscount: ApplyDiscountUseCaseImpl(repository: CheckoutRepositoryImpl()),
        completeDraftOrder: CompleteDraftOrderUseCaseImpl(repository: CheckoutRepositoryImpl()),
        updateDraftOrderAddress: UpdateDraftOrderAddressUseCaseImpl(repository: CheckoutRepositoryImpl()),
        removeLineItem: RemoveLineItemUseCaseImpl(repository: CheckoutRepositoryImpl()),
        deleteDraftOrder: DeleteDraftOrderUseCaseImpl(repository: CheckoutRepositoryImpl()),
        fetchActiveDiscountCodes: FetchActiveDiscountCodesUseCaseImpl(repository: CheckoutRepositoryImpl())
    )) {
        self.useCases = useCases
    }
    
    // MARK: - Intentions
    
    @MainActor
    func createInitialDraftOrder(lineItems: [DraftLineItemRequest]) async {
        self.cartLineItems = lineItems
        self.isLoading = true
        self.errorMessage = nil
        
        do {
            async let fetchCouponsTask = useCases.fetchActiveDiscountCodes.execute()
            async let draftOrderTask = useCases.createDraftOrder.execute(lineItems: lineItems)
            
            let (coupons, draftOrderResponse) = try await (fetchCouponsTask, draftOrderTask)
            
            self.activeCoupons = coupons
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
        
        if let index = cartLineItems.firstIndex(where: { $0.variantId == variantId }) {
            cartLineItems[index] = DraftLineItemRequest(variantId: variantId, quantity: newQuantity)
        }
        
        do {
            let response = try await useCases.updateDraftOrderLineItems.execute(
                draftOrderId: orderId,
                lineItems: cartLineItems
            )
            updateUI(with: response)
        } catch {
            self.errorMessage = error.localizedDescription
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
        
        let remainingItems = cartLineItems.filter { $0.variantId != variantId }
        
        do {
            if remainingItems.isEmpty {
                // Last item removed — delete the entire draft order
                try await useCases.deleteDraftOrder.execute(draftOrderId: orderId)
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
                    currentLineItems: cartLineItems
                )
                cartLineItems = remainingItems
                updateUI(with: response)
            }
        } catch {
            self.errorMessage = error.localizedDescription
        }
        
        self.isLoading = false
    }
    
    // MARK: - Private Helpers
    @MainActor
    func proceedToPayment() async {
        guard let orderId = draftOrderId else { return }
        self.isLoading = true
        self.errorMessage = nil
        
        do {
            let response = try await useCases.completeDraftOrder.execute(draftOrderId: orderId)
            
            updateUI(with: response)
            print("Successfully completed draft order into an actual order!")
        } catch {
            self.errorMessage = error.localizedDescription
        }
        
        self.isLoading = false
    }
    private func updateUI(with response: DraftOrderResponse) {
        self.draftOrderId = response.id
        self.subtotal = response.subtotalPrice
        self.tax = response.totalTax
        self.orderTotal = response.totalPrice
        
        let totalItemsPrice = response.lineItems.reduce(0.0) { sum, item in
            sum + ((Double(item.price) ?? 0.0) * Double(item.quantity))
        }
        self.originalSubtotal = String(format: "%.2f", totalItemsPrice)
        
        if let discount = response.appliedDiscount {
            self.discountAmount = discount.amount
        } else {
            self.discountAmount = "0.00"
        }
    }
}
