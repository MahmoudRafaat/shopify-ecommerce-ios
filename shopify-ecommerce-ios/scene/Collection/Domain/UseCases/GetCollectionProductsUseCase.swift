//
//  GetCollectionProductsUseCase.swift
//  shopify-ecommerce-ios
//
//  Created by albaraa alsayed on 20/01/1448 AH.
//

import Foundation

protocol GetCollectionProductsUseCase {
    func execute(collectionId: Int, searchQuery: String?) async throws -> (products: [ProductCollection], nextPageURL: URL?)
    func fetchNextPage(url: URL) async throws -> (products: [ProductCollection], nextPageURL: URL?)
}

class GetCollectionProductsUseCaseImp: GetCollectionProductsUseCase {
    private let repository: CollectionRepo
    
    init(repository: CollectionRepo) {
        self.repository = repository
    }
    
    func execute(collectionId: Int, searchQuery: String?) async throws -> (products: [ProductCollection], nextPageURL: URL?) {
        try await repository.getCollectionProducts(collectionId: collectionId, searchQuery: searchQuery)
    }
    
    func fetchNextPage(url: URL) async throws -> (products: [ProductCollection], nextPageURL: URL?) {
        try await repository.fetchNextPage(url: url)
    }
}
