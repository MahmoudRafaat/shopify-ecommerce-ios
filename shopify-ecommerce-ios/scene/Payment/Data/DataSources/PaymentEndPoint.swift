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
    case paymentCard(id: Int)

    var path: String {
        switch self {
        case .draftOrder(let id):
            return "draft_orders/\(id).json"
            
        case .paymentCard(let id):
            return "customers/\(id)/metafields.json?namespace=custom&key=payment_details"
        }
    }

    var method: HTTPMethod {
        .get
    }
}
