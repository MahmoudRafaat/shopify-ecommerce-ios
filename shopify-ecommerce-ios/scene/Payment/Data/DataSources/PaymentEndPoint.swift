//
//  PaymentEndPoint.swift
//  shopify-ecommerce-ios
//
//  Created by albaraa alsayed on 19/01/1448 AH.
//

import Foundation
import Alamofire

enum PaymentEndPoint: ApiEndpoint {
    case draftOrder(id: Int)

    var path: String {
        switch self {
        case .draftOrder(let id):
            return "/draft_orders/\(id).json"
        }
    }

    var method: HTTPMethod {
        .get
    }
}
