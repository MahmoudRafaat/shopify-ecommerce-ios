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
    case completeOrder(id: Int, paymentPending: Bool)

    var path: String {
        switch self {
        case .draftOrder(let id):
            return "/draft_orders/\(id).json"
        case .completeOrder(let id, _):
            return "/draft_orders/\(id)/complete.json"
        }
    }
    
    var queryParameters: Parameters? {
        switch self {
        case .draftOrder:
            return nil
        case .completeOrder(_, let paymentPending):
            return ["payment_pending": paymentPending]
        }
    }

    var method: HTTPMethod {
        switch self {
        case .draftOrder:
            return .get
        case .completeOrder:
            return .put
        }
    }
    
    var body: Data? {
        nil
    }
}
