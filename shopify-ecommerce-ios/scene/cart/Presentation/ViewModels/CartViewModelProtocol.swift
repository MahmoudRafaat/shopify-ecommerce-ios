//
//  CheckoutViewModelProtocol.swift
//  shopify-ecommerce-ios
//
//  Created by Ehab Salah on 03/07/2026.
//

import Foundation

protocol CartViewModelProtocol {
    var uiState: CartUIState { get set }
    
    func loadOrCreateCart(products: [ProductDataModel]) async
    func updateQuantity(for variantId: Int, to newQuantity: Int) async
    func applyDiscount() async
    func removeDiscount() async
    func clearCart() async
    func updateAddress(address: DraftAddressRequest) async
    func removeLineItem(variantId: Int) async
}
