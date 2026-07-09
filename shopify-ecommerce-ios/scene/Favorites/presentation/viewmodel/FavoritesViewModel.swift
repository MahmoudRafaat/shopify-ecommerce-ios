//
//  FavoritesViewModel.swift
//  shopify-ecommerce-ios
//
//  Created by Ehab Salah on 07/07/2026.
//

import Foundation
import SwiftUI



@MainActor
@Observable
final class FavoritesViewModel {
    private let useCases: FavoritesUseCases
    
    // MARK: - State
    var uiState = FavoritesUIState()
    
    init(useCases: FavoritesUseCases? = nil) {
        if let useCases {
            self.useCases = useCases
        } else {
            let repository = FavoritesRepositoryImpl()
            self.useCases = FavoritesUseCases(
                getFavorites: GetFavoritesUseCaseImpl(repository: repository),
                addFavorite: AddFavoriteUseCaseImpl(repository: repository),
                removeFavorite: RemoveFavoriteUseCaseImpl(repository: repository),
                checkFavorite: CheckFavoriteUseCaseImpl(repository: repository)
            )
        }
    }
    
    func fetchFavorites() {
        uiState.isLoading = true
        uiState.error = nil
        
        do {
            uiState.favorites = try useCases.getFavorites.execute()
            uiState.isLoading = false
        } catch {
            uiState.isLoading = false
            uiState.error = AppError.determine()
        }
    }
    
    func removeFavorite(id: Int) {
        do {
            try useCases.removeFavorite.execute(id: id)
            uiState.favorites.removeAll { $0.id == id }
        } catch {
            uiState.error = AppError.determine()
        }
    }
    
    func addFavorite(product: FavoriteProduct) {
        do {
            try useCases.addFavorite.execute(product: product)
            // Re-fetch or manually append. We will manually insert at the top based on our sort descriptor (reverse chronological)
            uiState.favorites.insert(product, at: 0)
        } catch {
            uiState.error = AppError.determine()
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
