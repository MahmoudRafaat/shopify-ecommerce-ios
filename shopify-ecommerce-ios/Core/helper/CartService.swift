//
//  CartService.swift
//  shopify-ecommerce-ios
//
//  Created on 06/07/2026.
//

import Foundation
import Observation
import Combine

@Observable
final class CartService {

    static let shared = CartService()

    private(set) var products: [ProductDataModel] = []
    
    /// Event bus for signaling that the cart has been completely cleared.
    let clearCartSubject = PassthroughSubject<Void, Never>()

    private init() {}



    func addProduct(_ product: ProductDataModel) -> Bool {
        guard !products.contains(where: { $0.variantId == product.variantId }) else {
            return false
        }
        products.append(product)
        return true
    }

    func removeProduct(variantId: Int) {
        products.removeAll { $0.variantId == variantId }
    }

    func clear() {
        products.removeAll()
        // Broadcast that the cart was cleared so ViewModels can drop remote state.
        clearCartSubject.send()
    }
    
    func sync(products: [ProductDataModel]) {
        self.products = products
    }
}

