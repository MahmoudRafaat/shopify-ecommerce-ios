//
//  NetworkManager.swift
//  shopify-ecommerce-ios
//
//  Created by albaraa alsayed on 16/01/1448 AH.
//

import Foundation
import Alamofire

enum NetworkError: Error {
    case invalidURL
    case serverError(String)
}

final class NetworkService {
    
    private static var baseURL: String {
        return "https://\(SecretConstants.apiKey):\(SecretConstants.password)@\(SecretConstants.hostname)/admin/api/2026-01/"
    }
    
    private static var decoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }
    
    static func getData<T: Decodable>(from endpoint: Endpoint) async throws -> T {
        let urlString = baseURL + endpoint.path
        
        guard URL(string: urlString) != nil else {
            throw NetworkError.invalidURL
        }
        
        return try await AF.request(
            urlString,
            method: endpoint.method,
            parameters: endpoint.queryParameters,
            encoding: URLEncoding.default,
            headers: endpoint.headers
        )
        .validate()
        .serializingDecodable(T.self, decoder: decoder)
        .value
    }
    
    static func sendData<T: Decodable, U: Encodable>(to endpoint: Endpoint, body: U) async throws -> T {
        let urlString = baseURL + endpoint.path
        
        guard URL(string: urlString) != nil else {
            throw NetworkError.invalidURL
        }
        
        return try await AF.request(
            urlString,
            method: endpoint.method,
            parameters: body,
            encoder: JSONParameterEncoder.default,
            headers: endpoint.headers
        )
        .validate()
        .serializingDecodable(T.self, decoder: decoder)
        .value
    }
}
