//
//  CollectionUIState.swift
//  shopify-ecommerce-ios
//
//  Created by albaraa alsayed on 24/01/1448 AH.
//

import Foundation

struct CollectionUIState {
    var products: [ProductCollection] = []
    var isLoading: Bool = true
    var isLoadingMore: Bool = false
    var error: AppError? = nil
}
