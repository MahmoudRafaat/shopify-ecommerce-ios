//
//  DraftOrderResponse.swift
//  shopify-ecommerce-ios
//
//  Created by Ehab Salah on 03/07/2026.
//

import Foundation

struct DraftOrderResponseWrapper: Codable {
    let draftOrder: DraftOrderResponse
}

struct DraftOrderResponse: Codable {
    let id: Int
    let name: String
    let subtotalPrice: String
    let totalTax: String
    let totalPrice: String
    let lineItems: [DraftLineItemResponse]
    let appliedDiscount: DraftAppliedDiscountResponse?
}

struct DraftLineItemResponse: Codable {
    let id: Int
    let variantId: Int?
    let title: String
    let quantity: Int
    let price: String
    let name: String
}

struct DraftAppliedDiscountResponse: Codable {
    let description: String?
    let value: String
    let title: String
    let amount: String
    let valueType: String
}
