//
//  ChaeckoutService.swift
//  shopify-ecommerce-ios
//
//  Created by albaraa alsayed on 19/01/1448 AH.
//

import Foundation

protocol PaymentServiceProtocol: AnyObject {
    func loadDraft() async throws -> PaymentOrderDTO?
    func completeOrder(id: Int, paymentPending: Bool) async throws
}

class PaymentService: PaymentServiceProtocol {
    func loadDraft() async throws -> PaymentOrderDTO? {
        let responce : PaymentOrderResponse = try await NetworkService.request(endpoint: PaymentEndPoint.draftOrder(id: 1076599390344))
        return responce.draftOrder
    }
    
    func completeOrder(id: Int, paymentPending: Bool) async throws {
        let _ : PaymentOrderResponse = try await NetworkService.request(endpoint: PaymentEndPoint.completeOrder(id: id, paymentPending: paymentPending))
    }
}
