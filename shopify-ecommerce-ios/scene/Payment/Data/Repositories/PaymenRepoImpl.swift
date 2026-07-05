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
        let order = try await service.loadDraft()

        return PaymentOrder(
            id: order.id,
            total: order.totalPrice,
            shipping: "00.00"
        )
    }
}
