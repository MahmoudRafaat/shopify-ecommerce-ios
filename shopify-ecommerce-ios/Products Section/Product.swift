//
//  Product.swift
//  shopify-ecommerce-ios
//
//  Created by albaraa alsayed on 13/01/1448 AH.
//

import Foundation

struct Product : Identifiable{
    let id: UUID = UUID()
    let image: String
    let name: String
    let description: String
    let price: Float
    let discount: Int
    
    var oldPrice: Float {
        return price / (1 - (Float(discount) / 100.0))
    }
    
    let stars: Float
    let reviewers: Int
}
