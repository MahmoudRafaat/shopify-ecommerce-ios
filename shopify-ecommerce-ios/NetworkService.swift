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
        return "https://\(SeacretConstants.apiKey):\(SeacretConstants.password)@\(SeacretConstants.hostname)/admin/api/2024-01/"
    }
    
    private static var decoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }
    
    static func request<T: Decodable>(
        endpoint: String,
        method: HTTPMethod = .get,
        parameters: Parameters? = nil,
        encoding: ParameterEncoding = URLEncoding.default,
        headers: HTTPHeaders? = nil
    ) async throws -> T {

        let urlString = baseURL + endpoint
        guard URL(string: urlString) != nil else {
            throw NetworkError.invalidURL
        }
        
        return try await AF.request(
            urlString,
            method: method,
            parameters: parameters,
            encoding: encoding,
            headers: headers
        )
        .validate()
        .serializingDecodable(T.self, decoder: decoder)
        .value
    }
    
    
    static func request<T: Decodable, U: Encodable>(
        endpoint: String,
        method: HTTPMethod = .post,
        parameters: U,
        encoder: ParameterEncoder = JSONParameterEncoder.default,
        headers: HTTPHeaders? = nil
    ) async throws -> T {
        
        let urlString = baseURL + endpoint
        guard URL(string: urlString) != nil else {
            throw NetworkError.invalidURL
        }
        
        var requestHeaders: HTTPHeaders = ["Content-Type": "application/json"]
        if let customHeaders = headers {
            customHeaders.forEach { requestHeaders.add($0) }
        }
        
        return try await AF.request(
            urlString,
            method: method,
            parameters: parameters,
            encoder: encoder,
            headers: requestHeaders
        )
        .validate()
        .serializingDecodable(T.self, decoder: decoder)
        .value
    }
}
