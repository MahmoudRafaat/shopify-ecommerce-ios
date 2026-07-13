//
//  SearchProductsUseCase.swift
//  shopify-ecommerce-ios
//
//  Created by albaraa alsayed on 20/01/1448 AH.
//

import Foundation

protocol SearchProductsUseCaseProtocol {
    func fetchProductsCount(query: ProductQuery) async throws -> Int
    func execute(query: ProductQuery) async throws -> (products: [SearchProduct], nextPageURL: URL?)
    func executeNextPage(url: URL) async throws -> (products: [SearchProduct], nextPageURL: URL?)
    func fetchFilterOptions() async throws -> (vendors: [SearchVendor], categories: [SearchCategory])
}

class SearchProductsUseCase: SearchProductsUseCaseProtocol {
    private let repository: SearchProductRepo
    
    init(repository: SearchProductRepo) {
        self.repository = repository
    }
    
    func fetchProductsCount(query: ProductQuery) async throws -> Int {
        return try await repository.fetchProductsCount(query: query)
    }
    
    func execute(query: ProductQuery) async throws -> (products: [SearchProduct], nextPageURL: URL?) {
        return try await repository.fetchProducts(query: query)
    }
    
    func executeNextPage(url: URL) async throws -> (products: [SearchProduct], nextPageURL: URL?) {
        return try await repository.fetchNextPage(url: url)
    }
    
    func fetchFilterOptions() async throws -> (vendors: [SearchVendor], categories: [SearchCategory]) {
        return try await repository.fetchFilterOptions()
    }
}
