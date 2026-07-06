//
//  FavoritesViewModel.swift
//  shopify-ecommerce-ios
//
//  Created by Ehab Salah on 07/07/2026.
//

import Foundation
import SwiftUI

@Observable
final class FavoritesViewModel {
    private let useCases: FavoritesUseCases
    
    // MARK: - State
    var favorites: [FavoriteProduct] = []
    var isLoading: Bool = false
    var errorMessage: String? = nil
    
    init(useCases: FavoritesUseCases = FavoritesUseCases(
        getFavorites: GetFavoritesUseCaseImpl(repository: FavoritesRepositoryImpl()),
        addFavorite: AddFavoriteUseCaseImpl(repository: FavoritesRepositoryImpl()),
        removeFavorite: RemoveFavoriteUseCaseImpl(repository: FavoritesRepositoryImpl()),
        checkFavorite: CheckFavoriteUseCaseImpl(repository: FavoritesRepositoryImpl())
    )) {
        self.useCases = useCases
    }
    
    func fetchFavorites() {
        isLoading = true
        errorMessage = nil
        
        do {
            favorites = try useCases.getFavorites.execute()
            isLoading = false
        } catch {
            isLoading = false
            errorMessage = error.localizedDescription
        }
    }
    
    func removeFavorite(id: Int) {
        do {
            try useCases.removeFavorite.execute(id: id)
            favorites.removeAll { $0.id == id }
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    func addFavorite(product: FavoriteProduct) {
        do {
            try useCases.addFavorite.execute(product: product)
            // Re-fetch or manually append. We will manually insert at the top based on our sort descriptor (reverse chronological)
            favorites.insert(product, at: 0)
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    func checkIsFavorite(id: Int) -> Bool {
        do {
            return try useCases.checkFavorite.execute(id: id)
        } catch {
            print("Error checking if favorite: \(error.localizedDescription)")
            return false
        }
    }
}
