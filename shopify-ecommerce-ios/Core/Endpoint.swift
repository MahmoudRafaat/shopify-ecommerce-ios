//
//  ApiEndpoint.swift
//  shopify-ecommerce-ios
//
//  Created by albaraa alsayed on 17/01/1448 AH.
//

import Foundation
import Alamofire

protocol Endpoint {
    var path: String { get }
    var method: HTTPMethod { get }
    var queryParameters: Parameters? { get }
    var headers: HTTPHeaders? { get }
}


extension Endpoint {
    var method: HTTPMethod {
        return .get
    }
    
    var queryParameters: Parameters? {
        return nil
    }
    
    var headers: HTTPHeaders? {
        return ["Content-Type": "application/json"]
    }
}
