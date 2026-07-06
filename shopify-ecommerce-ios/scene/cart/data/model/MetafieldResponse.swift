//
//  MetafieldResponse.swift
//  shopify-ecommerce-ios
//
//  Created by Ehab Salah on 03/07/2026.
//

import Foundation

struct MetafieldsResponseWrapper: Codable {
    let metafields: [MetafieldResponse]
}

struct SingleMetafieldResponseWrapper: Codable {
    let metafield: MetafieldResponse
}

struct MetafieldResponse: Codable {
    let id: Int
    let namespace: String
    let key: String
    let value: Int 
    let type: String
}
