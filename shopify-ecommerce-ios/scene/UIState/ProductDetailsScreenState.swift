//
//  ProductDetailsScreenState.swift
//  shopify-ecommerce-ios
//
//  Created by Yomna on 04/07/2026.
//

import Foundation

struct ProductDetailsScreenUIState {
    var isLoading: Bool = true
    var error: AppError? = nil
    var data: ProductDetailsUIState? = nil
}
