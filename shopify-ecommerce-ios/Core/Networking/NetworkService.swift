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
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }

    private static var shopifyEncoder: JSONParameterEncoder {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        return JSONParameterEncoder(encoder: encoder)
    }
    
    
    static func request<T: Decodable, Body: Encodable>(
        endpoint: ApiEndpoint,
        body: Body? = nil as Empty?
    ) async throws -> T {
        
        let urlString = Constants.baseURL + endpoint.path
        
        guard let url = URL(string: urlString) else {
            throw NetworkError.invalidURl
        }
        
        var urlRequest = try URLRequest(url: url, method: endpoint.method, headers: endpoint.headers)
        
        if let queryParameters = endpoint.queryParameters {
            urlRequest = try URLEncoding.default.encode(urlRequest, with: queryParameters)
        }
        
        if let body = body {
            urlRequest = try shopifyEncoder.encode(body, into: urlRequest)
        }
        
        let response = await AF.request(urlRequest)
            .validate()
            .serializingDecodable(T.self, decoder: decoder)
            .response
        
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
                        print("Shopify 422 – Raw JSON:\n\(JsonHelper.prettyJSON(data))")

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
