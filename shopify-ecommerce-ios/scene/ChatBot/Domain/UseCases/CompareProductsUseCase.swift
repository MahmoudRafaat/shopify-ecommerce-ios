//
//  CompareProductsUseCase.swift
//  shopify-ecommerce-ios
//
//  Created by Mahmoud Raafat Mustafa on 07/07/2026.
//

import Foundation

protocol CompareProductsUseCaseProtocol {
    func execute(product1: Product, product2: Product) async throws -> AIResponse
}

class CompareProductsUseCase: CompareProductsUseCaseProtocol {
    private let repository: ChatRepositoryProtocol

    init(repository: ChatRepositoryProtocol) {
        self.repository = repository
    }

    func execute(product1: Product, product2: Product) async throws -> AIResponse {
        return try await repository.compareProducts(product1, product2)
    }
}
