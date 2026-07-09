//
//  FavoritesUIState.swift
//  shopify-ecommerce-ios
//
//  Created by albaraa alsayed on 24/01/1448 AH.
//

import Foundation

struct FavoritesUIState {
    var favorites: [FavoriteProduct] = []
    var isLoading: Bool = false
    var error: AppError? = nil
}
