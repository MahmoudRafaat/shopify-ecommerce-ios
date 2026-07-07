//
//  CurrencyEndpoint.swift
//  shopify-ecommerce-ios
//

import Foundation
import Alamofire

enum CurrencyEndpoint: ApiEndpoint {
    case latestRates(base: String)
    
    var baseURL: String? {
        return "https://open.er-api.com"
    }
    
    var path: String {
        switch self {
        case .latestRates(let base):
            return "/v6/latest/\(base)"
        }
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var queryParameters: Parameters? {
        return nil
    }
    
    var headers: HTTPHeaders? {
        return nil
    }
    
    var body: Data? {
        return nil
    }
}
