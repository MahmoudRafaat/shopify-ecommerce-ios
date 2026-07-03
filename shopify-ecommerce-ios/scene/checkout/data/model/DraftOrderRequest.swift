//
//  DraftOrderRequest.swift
//  shopify-ecommerce-ios
//
//  Created by Ehab Salah on 03/07/2026.
//

import Foundation

struct DraftOrderRequestWrapper: Codable {
    let draftOrder: DraftOrderRequest
}

struct DraftOrderRequest: Codable {
    var id: Int? = nil
    var lineItems: [DraftLineItemRequest]? = nil
    var customer: DraftCustomerRequest? = nil
    var useCustomerDefaultAddress: Bool? = nil
    var appliedDiscount: DraftAppliedDiscountRequest? = nil
}

struct DraftLineItemRequest: Codable {
    let variantId: Int
    let quantity: Int
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
}
