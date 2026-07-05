//
//  DraftOrderResponse.swift
//  shopify-ecommerce-ios
//
//  Created by Ehab Salah on 03/07/2026.
//

import Foundation

struct DraftOrderResponseWrapper: Codable {
    let draftOrder: DraftOrderResponse
    
    enum CodingKeys: String, CodingKey {
        case draftOrder = "draft_order"
    }
}

struct DraftOrderResponse: Codable {
    let id: Int
    let name: String
    let subtotalPrice: String
    let totalTax: String
    let totalPrice: String
    let status: String?
    let lineItems: [DraftLineItemResponse]
    let appliedDiscount: DraftAppliedDiscountResponse?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case subtotalPrice = "subtotal_price"
        case totalTax = "total_tax"
        case totalPrice = "total_price"
        case status
        case lineItems = "line_items"
        case appliedDiscount = "applied_discount"
    }
}

struct DraftLineItemResponse: Codable {
    let id: Int
    let variantId: Int?
    let title: String
    let quantity: Int
    let price: String
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case variantId = "variant_id"
        case title
        case quantity
        case price
        case name
    }
}

struct DraftAppliedDiscountResponse: Codable {
    let description: String?
    let value: String
    let title: String
    let amount: String
    let valueType: String
    
    enum CodingKeys: String, CodingKey {
        case description
        case value
        case title
        case amount
        case valueType = "value_type"
    }
}
