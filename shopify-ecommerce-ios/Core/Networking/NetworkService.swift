//
//  NetworkManager.swift
//  shopify-ecommerce-ios
//
//  Created by albaraa alsayed on 16/01/1448 AH.
//

import Foundation
import Alamofire

final class NetworkService {
    
    private static var decoder: JSONDecoder {
        let decoder = JSONDecoder()
        return decoder
    }
    
    static func request<T: Decodable>(endpoint: ApiEndpoint) async throws -> T {
        
        let urlString = Constants.baseURL + endpoint.path
        
        guard let url = URL(string: urlString) else {
            throw NetworkError.invalidURl
        }
        
        var urlRequest = try URLRequest(url: url, method: endpoint.method, headers: endpoint.headers)
        
        if let queryParameters = endpoint.queryParameters {
            urlRequest = try URLEncoding.default.encode(urlRequest, with: queryParameters)
        }
        
        if let body = endpoint.body {
            urlRequest.httpBody = body
        }
        
        let response = await AF.request(urlRequest)
            .validate()
            .serializingDecodable(T.self, decoder: decoder)
            .response
        
        if let data = response.data {
            let method = endpoint.method.rawValue
            let status = response.response?.statusCode ?? 0
            print("[Network Log] \(method) \(urlString) [Status: \(status)]")
            print("Response JSON:\n\(JsonHelper.prettyJSON(data))\n-----------------------------")
        }
        
        switch response.result {
        case .success(let data):
            return data
            
        case .failure(let alamofireError):
            if let statusCode = response.response?.statusCode {
                switch statusCode {
                case 400: throw NetworkError.badRequest
                case 401: throw NetworkError.unauthorized
                case 404: throw NetworkError.notFound
                    
                case 422:
                    if let data = response.data {
                        
                        if let shopifyError = try? JSONDecoder().decode(
                            ShopifyErrorResponse.self, from: data
                        ) {
                            throw NetworkError.shopifyError(shopifyError.fullErrorMessage)
                        }
                    }
                    throw NetworkError.shopifyError("Shopify rejected the data provided (422).")
                    
                case 500...599: throw NetworkError.serverError
                default: throw NetworkError.unacceptableStatusCode(statusCode)
                }
            } else {
                print("Alamofire specific failure: \(alamofireError.localizedDescription)")
                throw NetworkError.unknown(0)
            }
        }
    }
}
