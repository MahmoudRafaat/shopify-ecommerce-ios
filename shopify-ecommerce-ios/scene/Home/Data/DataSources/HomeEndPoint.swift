//
//  HomeEndPoint.swift
//  shopify-ecommerce-ios
//
//  Created by albaraa alsayed on 17/01/1448 AH.
//

import Foundation
import Alamofire

enum HomeEndpoint: ApiEndpoint {
    case products
    case categories
    
    var path: String {
        switch self {
        case .products:
            return "products.json"
        case .categories:
            return "custom_collections.json"
        }
    }
    var method: Alamofire.HTTPMethod {
        return .get
    }
    var body: Data? {
        nil
    }
}
