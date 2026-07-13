//
//  CollectionEndPoints.swift
//  shopify-ecommerce-ios
//
//  Created by albaraa alsayed on 20/01/1448 AH.
//

import Foundation
import Alamofire

enum CollectionEndPoints : ApiEndpoint {
    
    case collectionProducts(collectionId: Int, searchQuery: String?)
    
    var path: String {
        switch self {
            case .collectionProducts:
            return "products.json"
        }
    }
    
    var method: Alamofire.HTTPMethod {
        return .get
    }
    
    var queryParameters: Parameters? {
        switch self {
        case .collectionProducts(let id, let searchQuery):
            var params: Parameters = [
                "collection_id": id,
                "limit": 20
            ]
            if let search = searchQuery, !search.isEmpty {
                params["title"] = search
            }
            return params
        }
    }
    
    var body: Data? {
        nil
    }
    
}
