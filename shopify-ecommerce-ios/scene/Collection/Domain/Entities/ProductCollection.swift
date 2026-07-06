//
//  ProductCollection.swift
//  shopify-ecommerce-ios
//
//  Created by albaraa alsayed on 20/01/1448 AH.
//

import Foundation

struct ProductCollection : Identifiable {
    let id: Int
    let image: String
    let name: String
    let description: String
    let price: Float
    let isAvailabe: Bool
    let productType: String
    let vendor: String
}
