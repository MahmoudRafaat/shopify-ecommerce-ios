//
//  GeminiStructuredReply.swift
//  shopify-ecommerce-ios
//
//  Created by Mahmoud Raafat Mustafa on 07/07/2026.
//

import Foundation

struct GeminiStructuredReply: Decodable {
    let reply: String
    let isInScope: Bool
    let isProductRecommendation: Bool
    let recommendedProductIds: [Int]
    let recommendedCategoryIds: [Int]
}
