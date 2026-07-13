//
//  SearchEndPoints.swift
//  shopify-ecommerce-ios
//
//  Created by albaraa alsayed on 20/01/1448 AH.
//

import Foundation
import Alamofire

enum SearchEndpoint: ApiEndpoint {
    case search(query: ProductQuery)
    case count(query: ProductQuery)
    case smartCollections
    case customCollections
    
    var path: String {
        switch self {
        case .search:
            return "products.json"
        case .count:
            return "products/count.json"
        case .smartCollections:
            return "smart_collections.json"
        case .customCollections:
            return "custom_collections.json"
        }
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var queryParameters: Parameters? {
        switch self {
        case .search(let query):
            var params: Parameters = [:]
            
            params["limit"] = 20
            
            if let title = query.title, !title.isEmpty {
                params["title"] = title
            }
            if let vendor = query.vendor, !vendor.isEmpty {
                params["vendor"] = vendor
            }
            if let collectionId = query.collectionId {
                params["collection_id"] = collectionId
            }
            if let order = query.order {
                params["order"] = order.rawValue
            }
            
            return params.isEmpty ? nil : params
            
        case .count(let query):
            var params: Parameters = [:]
            
            if let title = query.title, !title.isEmpty {
                params["title"] = title
            }
            if let vendor = query.vendor, !vendor.isEmpty {
                params["vendor"] = vendor
            }
            if let collectionId = query.collectionId {
                params["collection_id"] = collectionId
            }
            // count does not need limit or order
            
            return params.isEmpty ? nil : params
            
        case .smartCollections, .customCollections:
            return nil
        }
    }
    
    var body: Data? {
        return nil
    }
}
