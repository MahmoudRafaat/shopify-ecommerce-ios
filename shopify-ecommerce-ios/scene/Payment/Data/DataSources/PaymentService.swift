//
//  ChaeckoutService.swift
//  shopify-ecommerce-ios
//
//  Created by albaraa alsayed on 19/01/1448 AH.
//

import Foundation

protocol PaymentServiceProtocol: AnyObject {
    func loadDraft() async throws -> OrderDTO
}

class PaymentService: PaymentServiceProtocol {
    func loadDraft() async throws -> OrderDTO {
        let responce : OrderResponse = try await NetworkService.request(endpoint: PaymentEndPoint.draftOrder(id: 1076599390344))
        return responce.draftOrder
    }
}
