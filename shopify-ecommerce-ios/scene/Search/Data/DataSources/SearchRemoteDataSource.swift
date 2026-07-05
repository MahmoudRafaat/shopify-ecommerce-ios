//
//  SearchRemoteDataSource.swift
//  shopify-ecommerce-ios
//
//  Created by albaraa alsayed on 20/01/1448 AH.
//

import Foundation

protocol SearchDataSourceProtocol: AnyObject {
    func loadProducts(query: ProductQuery) async throws -> [ProductDTO]
    func loadSmartCollections() async throws -> [CategoryDTO]
    func loadCustomCollections() async throws -> [CategoryDTO]
}

class SearchRemoteDataSource: SearchDataSourceProtocol {
    
    func loadProducts(query: ProductQuery) async throws -> [ProductDTO] {
        let response: ProductsResponse = try await NetworkService.request(
            endpoint: SearchEndpoint.search(query: query)
        )
        return response.products
    }
    
    func loadSmartCollections() async throws -> [CategoryDTO] {
        let response: SmartCollectionResponse = try await NetworkService.request(
            endpoint: SearchEndpoint.smartCollections
        )
        return response.smartCollections
    }
    
    func loadCustomCollections() async throws -> [CategoryDTO] {
        let response: CategoryResponse = try await NetworkService.request(
            endpoint: SearchEndpoint.customCollections
        )
        return response.customCollections
    }
}
