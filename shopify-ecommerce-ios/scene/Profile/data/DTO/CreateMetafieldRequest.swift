//
//  CreateMetafieldRequest.swift
//  shopify-ecommerce-ios
//
//  Created by Mahmoud Raafat Mustafa on 04/07/2026.
//



struct CreateMetafieldRequest: Codable {
    let metafield: MetafieldRequest
}

struct UpdateMetafieldRequest: Codable {
    let metafield: MetafieldRequest
}

struct MetafieldRequest: Codable {
    let namespace: String
    let key: String
    let value: String
    let type: String
}
