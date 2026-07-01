//
//  APIRouter.swift
//  shopify-ecommerce-ios
//
//  Created by Mahmoud Raafat Mustafa on 01/07/2026.
//


import Foundation
import Alamofire

enum AuthEndpoints: URLRequestConvertible {
    case createCustomer(customer: CustomerInput)
    case searchCustomer(email: String)
    
    var baseURL: URL {
        return URL(string: NetworkConstants.BaseURL)!
    }
    
    var path: String {
        switch self {
        case .createCustomer:
            return "/customers.json"
        case .searchCustomer(let email):
            let encodedEmail = email.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? email
            return "/customers/search.json?query=email:\(encodedEmail)"
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
    
    var headers: HTTPHeaders {
        return [
            "Content-Type": "application/json",
            "X-Shopify-Access-Token": NetworkConstants.AdminToken
        ]
    }
    
    var parameters: Parameters? {
        switch self {
        case .createCustomer(let customer):
            return try? JSONEncoder().encode(customer).toDictionary()
        case .searchCustomer:
            return nil
        }
    }
    
    var encoding: ParameterEncoding {
        switch self {
        case .createCustomer:
            return JSONEncoding.default
        case .searchCustomer:
            return URLEncoding.default
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        var request = try URLRequest(url: baseURL.appendingPathComponent(path), method: method)
        request.headers = headers
        
        if let parameters = parameters {
            return try encoding.encode(request, with: parameters)
        }
        
        return request
    }
}

extension Encodable {
    func toDictionary() throws -> [String: Any] {
        let data = try JSONEncoder().encode(self)
        guard let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
            throw NSError(domain: "EncodingError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to convert to dictionary"])
        }
        return dictionary
    }
}
