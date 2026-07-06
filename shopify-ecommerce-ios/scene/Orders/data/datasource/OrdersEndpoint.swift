//
//  OrdersEndpoint.swift
//  shopify-ecommerce-ios
//
//  Created by Mahmoud Raafat Mustafa on 06/07/2026.
//


import Foundation
import Alamofire

enum OrdersEndpoint: ApiEndpoint {
    case getOrders(customerId: Int)
    
    var path: String {
        switch self {
        case .getOrders(let customerId):
            return "orders.json?customer_id=\(customerId)&status=any"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getOrders:
            return .get
        }
    }
    
    var body: Data? {
        switch self {
        case .getOrders:
            return nil
        }
    }
}
