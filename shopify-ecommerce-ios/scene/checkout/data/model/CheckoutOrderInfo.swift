//
//  CheckoutOrderInfo.swift
//  shopify-ecommerce-ios
//
//  Created by Ehab Salah on 03/07/2026.
//

import Foundation

struct CheckoutOrderInfo {
    let id: Int
    let subtotal: String
    let tax: String
    let total: String
    let originalSubtotal: String
    let discountAmount: String
    let status: String?
    let lineItems: [OrderItemUIModel]
}
