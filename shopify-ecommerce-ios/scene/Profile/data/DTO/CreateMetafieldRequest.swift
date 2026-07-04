//
//  CreateMetafieldRequest.swift
//  shopify-ecommerce-ios
//
//  Created by Mahmoud Raafat Mustafa on 04/07/2026.
//

struct CreateMetafieldRequest: Codable {
    let metafield: CreateMetafield
}

struct CreateMetafield: Codable {
    let namespace: String
    let key: String
    let value: String
    let type: String
}

struct UpdateMetafieldRequest: Codable {
    let metafield: UpdateMetafield
}

struct UpdateMetafield: Codable {
    let value: String
}










