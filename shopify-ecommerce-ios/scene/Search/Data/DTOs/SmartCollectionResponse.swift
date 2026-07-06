//
//  SmartCollectionResponse.swift
//  shopify-ecommerce-ios
//
//  Created by albaraa alsayed on 20/01/1448 AH.
//

import Foundation

struct SmartCollectionResponse: Codable {
    let smartCollections: [CategoryDTO]?
    
    enum CodingKeys: String, CodingKey {
        case smartCollections = "smart_collections"
    }
}
