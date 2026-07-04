//
//  CartRepository.swift
//  shopify-ecommerce-ios
//
//  Created by albaraa alsayed on 19/01/1448 AH.
//

import Foundation

protocol PaymentRepo {
    func getTotalPrice() async throws -> String
}
