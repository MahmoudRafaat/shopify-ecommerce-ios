//
//  ErrorHandler.swift
//  shopify-ecommerce-ios
//
//  Created by Ehab Salah on 01/07/2026.
//

import Foundation
import Alamofire

extension DataResponse {
    
    func validateAndHandlError() throws {
        let statusCode = self.response?.statusCode ?? 0
        
        if !(200...299).contains(statusCode) {
            switch statusCode {
            case 422:
                if let data = self.data,
                   let shopifyError = try? JSONDecoder().decode(ShopifyErrorResponse.self, from: data) {
                    throw NetworkError.shopifyError(shopifyError.fullErrorMessage)
                }
                throw NetworkError.unknown(422)
                
            case 400: throw NetworkError.badRequest
            case 401: throw NetworkError.unauthorized
            case 404: throw NetworkError.notFound
            case 500...599: throw NetworkError.serverError
                
            default:
                if let error = self.error {
                    throw error
                }
                throw NetworkError.unknown(statusCode)
            }
        }
    }
}
