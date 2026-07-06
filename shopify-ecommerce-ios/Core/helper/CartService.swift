//
//  CartService.swift
//  shopify-ecommerce-ios
//
//  Created on 06/07/2026.
//

import Foundation
import Observation

@Observable
final class CartService {

    static let shared = CartService()

    private(set) var products: [ProductDataModel] = []

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
    }
    
    func sync(products: [ProductDataModel]) {
        self.products = products
    }
}

