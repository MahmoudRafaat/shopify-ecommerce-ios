//
//  AuthEndopints.swift
//  shopify-ecommerce-ios
//
//  Created by Ehab Salah on 01/07/2026.
//

import Foundation
import Alamofire

enum AuthEndpoint: ApiEndpoint {
    case createCustomer(request: CustomerRequest)
    case searchCustomer(email: String)
    
    var body: Data? {
        switch self {
        case .createCustomer(let request):
            let encoder = JSONEncoder()
            encoder.keyEncodingStrategy = .convertToSnakeCase
            return try? encoder.encode(request)
            
        case .searchCustomer:
            return nil
        }
    }
    
    var path: String {
        switch self {
        case .createCustomer:
            return "customers.json"
        case .searchCustomer:
            return "customers/search.json"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .createCustomer:
            return .post
        case .searchCustomer:
            return .get
        }
    }
    
    var headers: HTTPHeaders? {
        return [
            "Content-Type": "application/json",
            "X-Shopify-Access-Token": Constants.adminToken
        ]
    }
    
    var queryParameters: Parameters? {
        switch self {
        case .searchCustomer(let email):
            let encodedEmail = email.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? email
            return ["query": "email:\(encodedEmail)"]
        default:
            return nil
        }
    }
}
