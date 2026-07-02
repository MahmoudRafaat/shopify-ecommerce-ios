//
//  GetCategoriesUseCase.swift
//  shopify-ecommerce-ios
//
//  Created by albaraa alsayed on 15/01/1448 AH.
//

import Foundation

protocol GetCategoriesUseCaseProtocol {
    func execute() async throws -> [Category]
}

class GetCategoriesUseCase: GetCategoriesUseCaseProtocol {
    private let repository: HomeRepo
    
    init(repository: HomeRepo) {
        self.repository = repository
    }
    
    func execute() async throws -> [Category] {
        return try await repository.getCategories()
    }
}
