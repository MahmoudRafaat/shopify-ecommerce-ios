//
//  PaymentOrder.swift
//  shopify-ecommerce-ios
//
//  Created by albaraa alsayed on 19/01/1448 AH.
//

import Foundation

struct PaymentOrder : Identifiable {
    let id: Int
    let total: String
    let shipping: String
}
