//
//  ProductDetailsEndPoint.swift
//  shopify-ecommerce-ios
//
//  Created by Yomna on 03/07/2026.
//

import Foundation
import Alamofire

enum ProductDetailsEndpoint: ApiEndpoint {

    case getProduct(id: Int)

    var path: String {
        switch self {
        case .getProduct(let id):
            return "/products/\(id).json"
        }
    }
    var method: HTTPMethod {
        .get
    }

    var body: Data? {
        nil
    }
}
