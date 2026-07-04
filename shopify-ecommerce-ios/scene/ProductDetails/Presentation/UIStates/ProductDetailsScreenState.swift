//
//  ProductDetailsScreenState.swift
//  shopify-ecommerce-ios
//
//  Created by Yomna on 04/07/2026.
//

import Foundation

enum ProductDetailsScreenState {
    case idle
    case loading
    case success(ProductDetailsUIState)
    case error(String)
}
