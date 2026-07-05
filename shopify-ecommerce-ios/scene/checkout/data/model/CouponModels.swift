//
//  CouponModels.swift
//  shopify-ecommerce-ios
//
//  Created by Ehab Salah on 05/07/2026.
//

import Foundation

struct PriceRulesResponseWrapper: Codable {
    let priceRules: [PriceRuleResponse]
    
    enum CodingKeys: String, CodingKey {
        case priceRules = "price_rules"
    }
}

struct PriceRuleResponse: Codable {
    let id: Int
    let title: String
    let value: String
    let valueType: String
    let startsAt: String?
    let endsAt: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case value
        case valueType = "value_type"
        case startsAt = "starts_at"
        case endsAt = "ends_at"
    }
}

struct DiscountCodesResponseWrapper: Codable {
    let discountCodes: [DiscountCodeResponse]
    
    enum CodingKeys: String, CodingKey {
        case discountCodes = "discount_codes"
    }
}

struct DiscountCodeResponse: Codable {
    let id: Int
    let priceRuleId: Int
    let code: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case priceRuleId = "price_rule_id"
        case code
    }
}
