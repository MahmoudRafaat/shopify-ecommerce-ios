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
    var shippingAddress: DraftAddressRequest? = nil
    var billingAddress: DraftAddressRequest? = nil
    
    enum CodingKeys: String, CodingKey {
        case id
        case lineItems = "line_items"
        case customer
        case useCustomerDefaultAddress = "use_customer_default_address"
        case appliedDiscount = "applied_discount"
        case shippingAddress = "shipping_address"
        case billingAddress = "billing_address"
    }
}

struct DraftLineItemRequest: Codable {
    let variantId: Int
    let quantity: Int
    let properties: [LineItemProperty]?
    
    enum CodingKeys: String, CodingKey {
        case variantId = "variant_id"
        case quantity
        case properties
    }
}

struct LineItemProperty: Codable {
    let name: String
    let value: String
}

struct DraftCustomerRequest: Codable {
    let id: Int
}

struct DraftAppliedDiscountRequest: Codable {
    let description: String
    let value: String
    let title: String
    let amount: String?
    let valueType: String // "fixed_amount" or "percentage"
    
    enum CodingKeys: String, CodingKey {
        case description
        case value
        case title
        case amount
        case valueType = "value_type"
    }
}

struct DraftAddressRequest: Codable {
    var firstName: String?
    var lastName: String?
    var address1: String?
    var city: String?
    var country: String?
    var phone: String?
    
    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case lastName = "last_name"
        case address1
        case city
        case country
        case phone
    }
}
