//
//  FavoritesUseCases.swift
//  shopify-ecommerce-ios
//
//  Created by Ehab Salah on 07/07/2026.
//

import Foundation

struct FavoritesUseCases {
    let getFavorites: GetFavoritesUseCase
    let addFavorite: AddFavoriteUseCase
    let removeFavorite: RemoveFavoriteUseCase
    let checkFavorite: CheckFavoriteUseCase
}

protocol GetFavoritesUseCase {
    func execute() throws -> [FavoriteProduct]
}

protocol AddFavoriteUseCase {
    func execute(product: FavoriteProduct) throws
}

protocol RemoveFavoriteUseCase {
    func execute(id: Int) throws
}

protocol CheckFavoriteUseCase {
    func execute(id: Int) throws -> Bool
}

// MARK: - Implementations

final class GetFavoritesUseCaseImpl: GetFavoritesUseCase {
    private let repository: FavoritesRepository
    
    init(repository: FavoritesRepository) {
        self.repository = repository
    }
    
    func execute() throws -> [FavoriteProduct] {
        return try repository.getFavorites()
    }
}

final class AddFavoriteUseCaseImpl: AddFavoriteUseCase {
    private let repository: FavoritesRepository
    
    init(repository: FavoritesRepository) {
        self.repository = repository
    }
    
    func execute(product: FavoriteProduct) throws {
        try repository.addFavorite(product)
    }
}

final class RemoveFavoriteUseCaseImpl: RemoveFavoriteUseCase {
    private let repository: FavoritesRepository
    
    init(repository: FavoritesRepository) {
        self.repository = repository
    }
    
    func execute(id: Int) throws {
        try repository.removeFavorite(withId: id)
    }
}

final class CheckFavoriteUseCaseImpl: CheckFavoriteUseCase {
    private let repository: FavoritesRepository
    
    init(repository: FavoritesRepository) {
        self.repository = repository
    }
    
    func execute(id: Int) throws -> Bool {
        return try repository.isFavorite(id: id)
    }
}
