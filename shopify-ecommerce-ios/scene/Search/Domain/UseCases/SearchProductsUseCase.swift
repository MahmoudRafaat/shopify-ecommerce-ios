//
//  SearchProductsUseCase.swift
//  shopify-ecommerce-ios
//
//  Created by albaraa alsayed on 20/01/1448 AH.
//

import Foundation

protocol SearchProductsUseCaseProtocol {
    func execute(query: ProductQuery) async throws -> [SearchProduct]
    func fetchFilterOptions() async throws -> (vendors: [SearchVendor], categories: [SearchCategory])
}

class SearchProductsUseCase: SearchProductsUseCaseProtocol {
    private let repository: SearchProductRepo
    
    init(repository: SearchProductRepo) {
        self.repository = repository
    }
    
    func execute(query: ProductQuery) async throws -> [SearchProduct] {
        let products = try await repository.fetchProducts(query: query)
        return products
    }
    
    func fetchFilterOptions() async throws -> (vendors: [SearchVendor], categories: [SearchCategory]) {
        return try await repository.fetchFilterOptions()
    }
}
