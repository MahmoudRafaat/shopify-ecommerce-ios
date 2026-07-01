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
        let urlString = "\(baseURL)products.json"
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        let response = try await AF.request(urlString)
            .validate()
            .serializingDecodable(ProductsResponse.self, decoder: decoder)
            .value
            
        return response.products
    }
    
    func loadCategories() async throws-> [CategoryDTO] {
        let urlString = "\(baseURL)custom_collections.json"
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let response = try await AF.request(urlString)
            .validate()
            .serializingDecodable(CategoryResponse.self,decoder: decoder)
            .value
        
        
        return response.customCollections
    }
    
    
}
