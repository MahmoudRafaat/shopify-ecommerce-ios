//
//  FavoritesLocalService.swift
//  shopify-ecommerce-ios
//
//  Created by Ehab Salah on 07/07/2026.
//

import Foundation
import SwiftData

@MainActor
final class FavoritesLocalService {
    
    private var modelContext: ModelContext {
        return ModelContext(SwiftDataHandler.shared.sharedModelContainer)
    }
    
    func save(product: FavoriteProduct) throws {
        let context = modelContext
        context.insert(product)
        try context.save()
    }
    
    func get() throws -> [FavoriteProduct] {
        let context = modelContext
        let fetchDescriptor = FetchDescriptor<FavoriteProduct>(sortBy: [SortDescriptor(\.dateAdded, order: .reverse)])
        return try context.fetch(fetchDescriptor)
    }
    
    func remove(id: Int) throws {
        let context = modelContext
        let predicate = #Predicate<FavoriteProduct> { $0.id == id }
        var fetchDescriptor = FetchDescriptor<FavoriteProduct>(predicate: predicate)
        fetchDescriptor.fetchLimit = 1
        
        let fetchedProducts = try context.fetch(fetchDescriptor)
        if let productToDelete = fetchedProducts.first {
            context.delete(productToDelete)
            try context.save()
        }
    }
    
    func isFavorite(id: Int) throws -> Bool {
        let context = modelContext
        let predicate = #Predicate<FavoriteProduct> { $0.id == id }
        var fetchDescriptor = FetchDescriptor<FavoriteProduct>(predicate: predicate)
        fetchDescriptor.fetchLimit = 1
        
        let count = try context.fetchCount(fetchDescriptor)
        return count > 0
    }
}
