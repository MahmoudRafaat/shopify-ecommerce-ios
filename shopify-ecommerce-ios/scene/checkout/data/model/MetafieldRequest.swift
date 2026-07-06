//
//  MetafieldRequest.swift
//  shopify-ecommerce-ios
//
//  Created by Ehab Salah on 05/07/2026.
//

import Foundation


struct MetafieldRequestWrapper: Codable {
    let metafield: MetafieldRequest
}

struct MetafieldRequest: Codable {
    let namespace: String
    let key: String
    let type: String
    let value: Int
}
