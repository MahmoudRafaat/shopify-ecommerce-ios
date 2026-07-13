//
//  SearchRemoteDataSource.swift
//  shopify-ecommerce-ios
//
//  Created by albaraa alsayed on 20/01/1448 AH.
//

import Foundation
import Alamofire

protocol SearchDataSourceProtocol: AnyObject {
    func loadProductsCount(query: ProductQuery) async throws -> Int
    func loadProducts(query: ProductQuery) async throws -> (products: [ProductDTO], nextPageURL: URL?)
    func loadNextPage(url: URL) async throws -> (products: [ProductDTO], nextPageURL: URL?)
    func loadSmartCollections() async throws -> [CategoryDTO]
    func loadCustomCollections() async throws -> [CategoryDTO]
}

class SearchRemoteDataSource: SearchDataSourceProtocol {
    
    func loadProductsCount(query: ProductQuery) async throws -> Int {
        let response: CountResponse = try await NetworkService.request(endpoint: SearchEndpoint.count(query: query))
        return response.count ?? 0
    }
    
    func loadProducts(query: ProductQuery) async throws -> (products: [ProductDTO], nextPageURL: URL?) {
        let endpoint = SearchEndpoint.search(query: query)
        let urlString = Constants.baseURL + endpoint.path
        
        guard let url = URL(string: urlString) else {
            throw NetworkError.invalidURl
        }
        
        var urlRequest = try URLRequest(url: url, method: endpoint.method, headers: endpoint.headers)
        
        if let queryParameters = endpoint.queryParameters {
            urlRequest = try URLEncoding.default.encode(urlRequest, with: queryParameters)
        }
        
        return try await executePaginatedRequest(urlRequest: urlRequest)
    }
    
    func loadNextPage(url: URL) async throws -> (products: [ProductDTO], nextPageURL: URL?) {
        let urlRequest = try URLRequest(url: url, method: .get, headers: ["Content-Type": "application/json"])
        return try await executePaginatedRequest(urlRequest: urlRequest)
    }
    
    private func executePaginatedRequest(urlRequest: URLRequest) async throws -> (products: [ProductDTO], nextPageURL: URL?) {
        let response = await AF.request(urlRequest)
            .validate()
            .serializingDecodable(ProductsResponse.self, decoder: JSONDecoder())
            .response
        
        switch response.result {
        case .success(let data):
            let nextURL = parseNextPageURL(from: response.response)
            return (products: data.products ?? [], nextPageURL: nextURL)
        case .failure(_):
            throw NetworkError.badRequest
        }
    }
    
    private func parseNextPageURL(from response: HTTPURLResponse?) -> URL? {
        guard let response = response, let linkHeader = response.value(forHTTPHeaderField: "Link") else { return nil }
        
        let segments = linkHeader.components(separatedBy: ",")
        for segment in segments {
            let trimmed = segment.trimmingCharacters(in: .whitespaces)
            guard trimmed.lowercased().contains("rel=\"next\"") else { continue }
            
            guard let openAngle = trimmed.firstIndex(of: "<"),
                  let closeAngle = trimmed.firstIndex(of: ">"),
                  openAngle < closeAngle else { continue }
            
            let urlString = String(trimmed[trimmed.index(after: openAngle)..<closeAngle])
            return URL(string: urlString)
        }
        return nil
    }
    
    func loadSmartCollections() async throws -> [CategoryDTO] {
        let response: SmartCollectionResponse = try await NetworkService.request(
            endpoint: SearchEndpoint.smartCollections
        )
        return response.smartCollections ?? []
    }
    
    func loadCustomCollections() async throws -> [CategoryDTO] {
        let response: CategoryResponse = try await NetworkService.request(
            endpoint: SearchEndpoint.customCollections
        )
        return response.customCollections ?? []
    }
}
