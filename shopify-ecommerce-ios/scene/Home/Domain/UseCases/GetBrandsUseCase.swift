//
//  GetBrandsUseCase.swift
//  shopify-ecommerce-ios
//

import Foundation

protocol GetBrandsUseCaseProtocol {
    func execute() async throws -> [Category]
}

class GetBrandsUseCase: GetBrandsUseCaseProtocol {
    private let repository: HomeRepo
    
    init(repository: HomeRepo) {
        self.repository = repository
    }
    
    func execute() async throws -> [Category] {
        return try await repository.getBrands()
    }
}
