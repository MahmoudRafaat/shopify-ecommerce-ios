//
//  FavoritesRepositoryImpl.swift
//  shopify-ecommerce-ios
//
//  Created by Ehab Salah on 07/07/2026.
//

import Foundation

@MainActor
final class FavoritesRepositoryImpl: FavoritesRepository {
    private let localService: FavoritesLocalService
    
    init(localService: FavoritesLocalService? = nil) {
        self.localService = localService ?? FavoritesLocalService()
    }
    
    func getFavorites() throws -> [FavoriteProduct] {
        return try localService.get()
    }
    
    func addFavorite(_ product: FavoriteProduct) throws {
        try localService.save(product: product)
    }
    
    func removeFavorite(withId id: Int) throws {
        try localService.remove(id: id)
    }
    
    func isFavorite(id: Int) throws -> Bool {
        return try localService.isFavorite(id: id)
    }
}
