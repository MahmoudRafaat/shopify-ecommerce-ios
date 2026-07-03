//
//  CheckoutViewModel.swift
//  shopify-ecommerce-ios
//
//  Created by Ehab Salah on 03/07/2026.
//


import Foundation
import SwiftUI

protocol CheckoutViewModelProtocol {
    var isLoading: Bool { get }
    var errorMessage: String? { get }
    var draftOrderId: Int? { get }
    var orderTotal: String { get }
    var subtotal: String { get }
    var tax: String { get }
    var discountAmount: String { get }
    var currentVariantId: Int { get }
    var currentQuantity: Int { get }
    var discountCode: String { get set }
    
    func createInitialDraftOrder(variantId: Int, quantity: Int) async
    func updateQuantity(to newQuantity: Int) async
    func updateSize(toVariantId newVariantId: Int) async
    func applyDiscount(code: String) async
    func proceedToPayment() async
}

@Observable
final class CheckoutViewModel: CheckoutViewModelProtocol {
    
    // MARK: - Dependencies
    private let useCases: CheckoutUseCases
    
    // MARK: - State
    var isLoading = false
    var errorMessage: String?
    
    // Draft Order details
    var draftOrderId: Int?
    var orderTotal: String = "0.00"
    var subtotal: String = "0.00"
    var tax: String = "0.00"
    var discountAmount: String = "0.00"
    
    // Request State
    var currentVariantId: Int = 0
    var currentQuantity: Int = 1
    var discountCode: String = ""
    
    init(useCases: CheckoutUseCases = CheckoutUseCases(
        createDraftOrder: CreateDraftOrderUseCaseImpl(repository: CheckoutRepositoryImpl()),
        updateDraftOrderLineItems: UpdateDraftOrderLineItemsUseCaseImpl(repository: CheckoutRepositoryImpl()),
        applyDiscount: ApplyDiscountUseCaseImpl(repository: CheckoutRepositoryImpl())
    )) {
        self.useCases = useCases
    }
    
    // MARK: - Intentions
    
    @MainActor
    func createInitialDraftOrder(variantId: Int, quantity: Int) async {
        self.currentVariantId = variantId
        self.currentQuantity = quantity
        
        self.isLoading = true
        self.errorMessage = nil
        
        do {
            let response = try await useCases.createDraftOrder.execute(
                variantId: variantId,
                quantity: quantity
            )
            updateUI(with: response)
        } catch {
            self.errorMessage = error.localizedDescription
        }
        
        self.isLoading = false
    }
    
    @MainActor
    func updateQuantity(to newQuantity: Int) async {
        guard let orderId = draftOrderId else { return }
        self.currentQuantity = newQuantity
        
        self.isLoading = true
        self.errorMessage = nil
        
        do {
            let lineItems = [DraftLineItemRequest(variantId: currentVariantId, quantity: newQuantity)]
            let response = try await useCases.updateDraftOrderLineItems.execute(
                draftOrderId: orderId,
                lineItems: lineItems
            )
            updateUI(with: response)
        } catch {
            self.errorMessage = error.localizedDescription
        }
        
        self.isLoading = false
    }
    
    @MainActor
    func updateSize(toVariantId newVariantId: Int) async {
        guard let orderId = draftOrderId else { return }
        self.currentVariantId = newVariantId
        
        self.isLoading = true
        self.errorMessage = nil
        
        do {
            let lineItems = [DraftLineItemRequest(variantId: newVariantId, quantity: currentQuantity)]
            let response = try await useCases.updateDraftOrderLineItems.execute(
                draftOrderId: orderId,
                lineItems: lineItems
            )
            updateUI(with: response)
        } catch {
            self.errorMessage = error.localizedDescription
        }
        
        self.isLoading = false
    }
    
    @MainActor
    func applyDiscount(code: String) async {
        guard let orderId = draftOrderId, !code.isEmpty else { return }
        
        self.isLoading = true
        self.errorMessage = nil
        
        do {
            let response = try await useCases.applyDiscount.execute(
                draftOrderId: orderId,
                discountCode: code
            )
            updateUI(with: response)
        } catch {
            self.errorMessage = error.localizedDescription
        }
        
        self.isLoading = false
    }
    
    @MainActor
    func proceedToPayment() async {
        guard let orderId = draftOrderId else { return }
        print("Proceeding to payment for draft order \(orderId)...")
    }
    
    // MARK: - Private Helpers
    
    private func updateUI(with response: DraftOrderResponse) {
        self.draftOrderId = response.id
        self.subtotal = response.subtotalPrice
        self.tax = response.totalTax
        self.orderTotal = response.totalPrice
        
        if let discount = response.appliedDiscount {
            self.discountAmount = discount.amount
        } else {
            self.discountAmount = "0.00"
        }
    }
}
