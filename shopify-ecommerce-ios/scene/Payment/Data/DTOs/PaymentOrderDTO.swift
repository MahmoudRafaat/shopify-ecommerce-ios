//
//  OrderDTO.swift
//  shopify-ecommerce-ios
//
//  Created by albaraa alsayed on 19/01/1448 AH.
//

import Foundation

struct PaymentOrderDTO : Decodable {
    let id: Int?
    let totalPrice : String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case totalPrice = "total_price"
    }
}
