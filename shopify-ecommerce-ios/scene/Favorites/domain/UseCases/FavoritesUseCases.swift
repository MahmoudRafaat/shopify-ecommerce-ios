//
//  FavoritesUseCases.swift
//  shopify-ecommerce-ios
//
//  Created by Ehab Salah on 07/07/2026.
//

import Foundation

@MainActor
struct FavoritesUseCases {
    let getFavorites: GetFavoritesUseCase
    let addFavorite: AddFavoriteUseCase
    let removeFavorite: RemoveFavoriteUseCase
    let checkFavorite: CheckFavoriteUseCase
}

@MainActor
protocol GetFavoritesUseCase {
    func execute() throws -> [FavoriteProduct]
}

@MainActor
protocol AddFavoriteUseCase {
    func execute(product: FavoriteProduct) throws
}

@MainActor
protocol RemoveFavoriteUseCase {
    func execute(id: Int) throws
}

@MainActor
protocol CheckFavoriteUseCase {
    func execute(id: Int) throws -> Bool
}

// MARK: - Implementations

@MainActor
final class GetFavoritesUseCaseImpl: GetFavoritesUseCase {
    private let repository: FavoritesRepository
    
    init(repository: FavoritesRepository) {
        self.repository = repository
    }
    
    func execute() throws -> [FavoriteProduct] {
        return try repository.getFavorites()
    }
}

@MainActor
final class AddFavoriteUseCaseImpl: AddFavoriteUseCase {
    private let repository: FavoritesRepository
    
    init(repository: FavoritesRepository) {
        self.repository = repository
    }
    
    func execute(product: FavoriteProduct) throws {
        try repository.addFavorite(product)
    }
}

@MainActor
final class RemoveFavoriteUseCaseImpl: RemoveFavoriteUseCase {
    private let repository: FavoritesRepository
    
    init(repository: FavoritesRepository) {
        self.repository = repository
    }
    
    func execute(id: Int) throws {
        try repository.removeFavorite(withId: id)
    }
}

@MainActor
final class CheckFavoriteUseCaseImpl: CheckFavoriteUseCase {
    private let repository: FavoritesRepository
    
    init(repository: FavoritesRepository) {
        self.repository = repository
    }
    
    func execute(id: Int) throws -> Bool {
        return try repository.isFavorite(id: id)
    }
}
