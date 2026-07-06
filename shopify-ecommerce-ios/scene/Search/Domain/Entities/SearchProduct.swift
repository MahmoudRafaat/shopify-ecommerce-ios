//
//  SearchProduct.swift
//  shopify-ecommerce-ios
//
//  Created by albaraa alsayed on 20/01/1448 AH.
//

import Foundation

struct SearchProduct : Identifiable {
    let id: Int
    let image: String
    let name: String
    let description: String
    let vendor: String
    let price: Float
    let isAvailabe: Bool
    let productType: String
}
