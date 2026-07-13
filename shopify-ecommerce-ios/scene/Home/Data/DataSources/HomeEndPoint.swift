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
    case brands
    case collectionProducts(id: Int)
    
    var path: String {
        switch self {
        case .products, .collectionProducts:
            return "products.json"
        case .categories:
            return "custom_collections.json"
        case .brands:
            return "smart_collections.json"
        }
    }
    var method: Alamofire.HTTPMethod {
        return .get
    }
    var queryParameters: Parameters? {
        switch self {
        case .collectionProducts(let id):
            return ["collection_id": id]
        default:
            return nil
        }
    }
    var body: Data? {
        nil
    }
}
