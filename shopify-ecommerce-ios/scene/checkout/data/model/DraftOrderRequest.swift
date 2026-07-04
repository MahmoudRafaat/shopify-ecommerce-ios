//
//  DraftOrderRequest.swift
//  shopify-ecommerce-ios
//
//  Created by Ehab Salah on 03/07/2026.
//

import Foundation

struct DraftOrderRequestWrapper: Codable {
    let draftOrder: DraftOrderRequest
    
    enum CodingKeys: String, CodingKey {
        case draftOrder = "draft_order"
    }
}

struct DraftOrderRequest: Codable {
    var id: Int? = nil
    var lineItems: [DraftLineItemRequest]? = nil
    var customer: DraftCustomerRequest? = nil
    var useCustomerDefaultAddress: Bool? = nil
    var appliedDiscount: DraftAppliedDiscountRequest? = nil
    
    enum CodingKeys: String, CodingKey {
        case id
        case lineItems = "line_items"
        case customer
        case useCustomerDefaultAddress = "use_customer_default_address"
        case appliedDiscount = "applied_discount"
    }
}

struct DraftLineItemRequest: Codable {
    let variantId: Int
    let quantity: Int
    
    enum CodingKeys: String, CodingKey {
        case variantId = "variant_id"
        case quantity
    }
}

struct DraftCustomerRequest: Codable {
    let id: Int
}

struct DraftAppliedDiscountRequest: Codable {
    let description: String
    let value: String
    let title: String
    let amount: String
    let valueType: String // "fixed_amount" or "percentage"
    
    enum CodingKeys: String, CodingKey {
        case description
        case value
        case title
        case amount
        case valueType = "value_type"
    }
}
