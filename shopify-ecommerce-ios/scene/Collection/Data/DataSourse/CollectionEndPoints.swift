//
//  CollectionEndPoints.swift
//  shopify-ecommerce-ios
//
//  Created by albaraa alsayed on 20/01/1448 AH.
//

import Foundation
import Alamofire

enum CollectionEndPoints : ApiEndpoint {
    
    case collectionProducts(collectionId: Int)
    
    var path: String {
        switch self {
            case .collectionProducts(let id):
            return "/products.json?collection_id=\(id)"
        }
    }
    
    var method: Alamofire.HTTPMethod {
        return .get
    }
    
    var body: Data? {
        nil
    }
    
}
