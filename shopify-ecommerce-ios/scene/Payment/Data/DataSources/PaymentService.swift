//
//  ChaeckoutService.swift
//  shopify-ecommerce-ios
//
//  Created by albaraa alsayed on 19/01/1448 AH.
//

import Foundation

protocol PaymentServiceProtocol: AnyObject {
    func loadDraft() async throws -> OrderDTO
    func loadPaymentCards() async throws -> [PaymentCardDTO]
}

class PaymentService: PaymentServiceProtocol {
    func loadDraft() async throws -> OrderDTO {
        let responce : OrderResponse = try await NetworkService.request(endpoint: PaymentEndPoint.draftOrder(id: 1076789903496))
        return responce.draftOrder
    }
    
    func loadPaymentCards() async throws -> [PaymentCardDTO] {
        let response : PaymentCardResponse = try await NetworkService.request(endpoint: PaymentEndPoint.paymentCard(id: 9202333384840))
        return response.metafields
    }
}
