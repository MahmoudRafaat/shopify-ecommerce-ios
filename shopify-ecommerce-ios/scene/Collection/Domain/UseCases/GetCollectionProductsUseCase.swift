//
//  GetCollectionProductsUseCase.swift
//  shopify-ecommerce-ios
//
//  Created by albaraa alsayed on 20/01/1448 AH.
//

import Foundation

protocol GetCollectionProductsUseCase {
    func execute(collectionId: Int) async throws -> [Product]
}

class GetCollectionProductsUseCaseImp: GetCollectionProductsUseCase {
    private let repository: CollectionRepo
    
    init(repository: CollectionRepo) {
        self.repository = repository
    }
    
    func execute(collectionId: Int) async throws -> [Product] {
        try await repository.getCollectionProducts(collectionId: collectionId)
    }
}
