//
//  GetProductUserCase.swift
//  shopify-ecommerce-ios
//
//  Created by albaraa alsayed on 15/01/1448 AH.
//

import Foundation

protocol GetProductsUseCaseProtocol {
    func execute() async throws -> [Product]
    func execute(collectionId: Int) async throws -> [Product]
}

class GetProductsUseCase: GetProductsUseCaseProtocol {
    private let repository: HomeRepo
    
    init(repository: HomeRepo) {
        self.repository = repository
    }
    
    func execute() async throws -> [Product] {
        return try await repository.getProducts()
    }
    
    func execute(collectionId: Int) async throws -> [Product] {
        return try await repository.getProductsByCollection(id: collectionId)
    }
}
