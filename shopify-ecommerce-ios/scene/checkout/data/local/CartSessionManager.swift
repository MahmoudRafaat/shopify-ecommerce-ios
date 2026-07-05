//
//  CouponModels.swift
//  shopify-ecommerce-ios
//
//  Created by Ehab Salah on 05/07/2026.
//

import Foundation

final class CartSessionManager {
    static let shared = CartSessionManager()
    
    private init() {}
    
    private func getCartKey() -> String? {
        
        guard let customerId = UserDefaults.standard.string(forKey: AppConstants.customerId) else {
            return nil
        }
        return "draft_order_cart_id_\(customerId)"
    }
    
    func saveCartId(_ id: Int) {
        guard let key = getCartKey() else { return }
        UserDefaults.standard.set(id, forKey: key)
    }
    
    func getCartId() -> Int? {
        guard let key = getCartKey() else { return nil }
        let id = UserDefaults.standard.integer(forKey: key)
        return id == 0 ? nil : id
    }
    
    func clearCartId() {
        guard let key = getCartKey() else { return }
        UserDefaults.standard.removeObject(forKey: key)
    }
}
