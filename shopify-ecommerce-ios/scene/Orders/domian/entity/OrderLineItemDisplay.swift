//
//  OrderLineItemDisplay.swift
//  shopify-ecommerce-ios
//
//  Created by Mahmoud Raafat Mustafa on 06/07/2026.
//

import Foundation

struct OrderLineItemDisplay: Identifiable, Hashable { 
    let id: Int
    let title: String
    let quantity: Int
    let price: String
    let sku: String?
    let vendor: String?
    let variantTitle: String?
    
    var displayName: String {
        if let variantTitle = variantTitle, !variantTitle.isEmpty {
            return "\(title) - \(variantTitle)"
        }
        return title
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: OrderLineItemDisplay, rhs: OrderLineItemDisplay) -> Bool {
        lhs.id == rhs.id
    }
    
    init(from dto: OrderLineItemDTO) {
        self.id = dto.id
        self.title = dto.title
        self.quantity = dto.quantity
        self.price = dto.price
        self.sku = dto.sku
        self.vendor = dto.vendor
        self.variantTitle = dto.variantTitle
    }
}
