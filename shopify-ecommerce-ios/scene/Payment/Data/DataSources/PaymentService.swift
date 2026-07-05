//
//  ChaeckoutService.swift
//  shopify-ecommerce-ios
//
//  Created by albaraa alsayed on 19/01/1448 AH.
//

import Foundation

protocol PaymentServiceProtocol: AnyObject {
    func loadDraft() async throws -> [OrderDTO]
}

class PaymentService: PaymentServiceProtocol {
    func loadDraft() async throws -> [OrderDTO] {
     return [OrderDTO(id: 1, totalPrice: "20")]
    }
}
