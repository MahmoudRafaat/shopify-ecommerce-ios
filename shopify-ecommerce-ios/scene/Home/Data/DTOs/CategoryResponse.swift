//
//  CategoryResponse.swift
//  shopify-ecommerce-ios
//
//  Created by Yomna on 30/06/2026.
//


struct CategoryResponse: Codable {
    let customCollections: [CategoryDTO]
    
    enum CodingKeys: String, CodingKey {
        case customCollections = "custom_collections"
    }
}
