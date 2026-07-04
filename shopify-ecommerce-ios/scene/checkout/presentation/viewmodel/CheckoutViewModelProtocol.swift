//
//  CheckoutViewModelProtocol.swift
//  shopify-ecommerce-ios
//
//  Created by Ehab Salah on 03/07/2026.
//

import Foundation

protocol CheckoutViewModelProtocol {
    var isLoading: Bool { get }
    var errorMessage: String? { get }
    var draftOrderId: Int? { get }
    var orderTotal: String { get }
    var subtotal: String { get }
    var tax: String { get }
    var discountAmount: String { get }
    var cartLineItems: [DraftLineItemRequest] { get }
    var discountCode: String { get set }
    var currentAddress: DraftAddressRequest? { get }
    var isAddressSheetPresented: Bool { get set }
    
    func createInitialDraftOrder(lineItems: [DraftLineItemRequest]) async
    func updateQuantity(for variantId: Int, to newQuantity: Int) async
    func applyDiscount(code: String) async
    func proceedToPayment() async
    func updateAddress(address: DraftAddressRequest) async
}
