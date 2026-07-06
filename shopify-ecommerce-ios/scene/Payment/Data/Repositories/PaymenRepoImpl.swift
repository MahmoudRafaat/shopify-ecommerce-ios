//
//  CartRepoImpl.swift
//  shopify-ecommerce-ios
//
//  Created by albaraa alsayed on 19/01/1448 AH.
//

import Foundation

class PaymentRepoImpl: PaymentRepo {
    private let service: PaymentServiceProtocol

    init(service: PaymentServiceProtocol) {
        self.service = service
    }

    func getTotalPrice() async throws -> PaymentOrder {
        guard let order = try await service.loadDraft() else {
            throw NetworkError.unknown(0)
        }

        return PaymentOrder(
            id: order.id ?? 0,
            total: order.totalPrice ?? "0.0",
            shipping: "00.00"
        )
    }
    
    func completeOrder(id: Int, paymentPending: Bool) async throws {
        try await service.completeOrder(id: id, paymentPending: paymentPending)
    }
}
