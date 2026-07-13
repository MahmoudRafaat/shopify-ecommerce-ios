//
//  MetafieldsResponse.swift
//  shopify-ecommerce-ios
//
//  Created by Mahmoud Raafat Mustafa on 03/07/2026.
//


import Foundation


struct MetafieldsResponse: Codable {
    let metafields: [MetafieldDTO]
}

struct PaymentMetafieldResponse: Codable {
    let metafield: MetafieldDTO
}

struct MetafieldDTO: Codable {
    let id: Int
    let namespace: String
    let key: String
    let value: String
    let type: String
    let createdAt: String?
    let updatedAt: String?
    
    enum CodingKeys: String, CodingKey {
        case id, namespace, key, value, type
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

