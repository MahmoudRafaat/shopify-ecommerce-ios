//
//  Product.swift
//  shopify-ecommerce-ios
//
//  Created by albaraa alsayed on 13/01/1448 AH.
//

import Foundation

struct Product : Identifiable {
    let id: Int
    let image: String
    let name: String
    let description: String
    let price: Float
    let isAvailabe: Bool
    let discount: Int = 20
    let productType: String
    
    var oldPrice: Float {
        return price / (1 - (Float(discount) / 100.0))
    }
    
    let stars: Float = 5
    let reviewers: Int = 1098
}
