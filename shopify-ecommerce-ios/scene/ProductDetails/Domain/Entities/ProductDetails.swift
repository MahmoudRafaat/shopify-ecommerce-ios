//
//  ProductDetails.swift
//  shopify-ecommerce-ios
//
//  Created by Yomna on 04/07/2026.
//

import Foundation

struct ProductDetails {

    let id: Int
    let title: String
    let description: String
    let vendor: String
    let productType: String
    let tags: [String]

    let images: [ProductDetailsImage]
    let variants: [ProductDetailsVariant]
}


struct ProductDetailsVariant {

    let id: Int
    let title: String
    let price: String
}


struct ProductDetailsImage {

    let id: Int
    let src: String
}
