//
//  HomeService.swift
//  shopify-ecommerce-ios
//
//  Created by albaraa alsayed on 15/01/1448 AH.
//

import Foundation
import Alamofire

protocol HomeServiceProtocol: AnyObject {
    func loadProducts() async throws -> [ProductDTO]
    func loadCategories() async throws -> [CategoryDTO]
}

class HomeRemoteDataSource: HomeServiceProtocol {
    private let baseURL: String
    
    init(baseURL: String) {
        self.baseURL = baseURL
    }
    
    func loadProducts() async throws -> [ProductDTO] {
        let response : ProductsResponse = try await NetworkService.request(endpoint: "products.json")
        return response.products
    }
    
    func loadCategories() async throws-> [CategoryDTO] {
        let response : CategoryResponse = try await NetworkService.request(endpoint: "custom_collections.json")
        return response.customCollections
    }
}
