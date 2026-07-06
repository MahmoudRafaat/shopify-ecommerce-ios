//
//  FavoritesRepository.swift
//  shopify-ecommerce-ios
//
//  Created by Ehab Salah on 07/07/2026.
//

import Foundation

protocol FavoritesRepository {
    func getFavorites() throws -> [FavoriteProduct]
    func addFavorite(_ product: FavoriteProduct) throws
    func removeFavorite(withId id: Int) throws
    func isFavorite(id: Int) throws -> Bool
}
