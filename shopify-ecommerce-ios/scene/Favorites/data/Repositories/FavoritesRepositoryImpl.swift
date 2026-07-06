//
//  FavoritesRepositoryImpl.swift
//  shopify-ecommerce-ios
//
//  Created by Ehab Salah on 07/07/2026.
//

import Foundation

final class FavoritesRepositoryImpl: FavoritesRepository {
    private let localService: FavoritesLocalService
    
    init(localService: FavoritesLocalService = FavoritesLocalService()) {
        self.localService = localService
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
