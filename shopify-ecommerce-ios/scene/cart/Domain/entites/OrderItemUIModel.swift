//
//  OrderItemUIModel.swift
//  shopify-ecommerce-ios
//
//  Created by Ehab Salah on 05/07/2026.
//

import Foundation

struct OrderItemUIModel: Identifiable {
    let id: Int // -> variant id
    let title: String
    let variantTitle: String 
    let price: String
    let quantity: Int
    let imageUrl: String?
}
