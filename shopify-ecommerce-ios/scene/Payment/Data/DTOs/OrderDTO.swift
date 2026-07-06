//
//  OrderDTO.swift
//  shopify-ecommerce-ios
//
//  Created by albaraa alsayed on 19/01/1448 AH.
//

import Foundation

struct OrderDTO : Decodable {
    let id: Int
    let totalPrice : String
}
