//
//  PaymenRepoImpl.swift
//  shopify-ecommerce-ios
//
//  Created by albaraa alsayed on 19/01/1448 AH.
//

import Foundation

/// Concrete implementation of `PaymentRepo`.
/// Routes Shopify order calls through `PaymentServiceProtocol` and
/// Paymob payment calls through `PaymobServiceProtocol`.
@MainActor
final class PaymentRepoImpl: PaymentRepo {

    // MARK: - Dependencies

    private let service: PaymentServiceProtocol
    private let paymobService: PaymobServiceProtocol

    // MARK: - Init

    init(service: PaymentServiceProtocol, paymobService: PaymobServiceProtocol) {
        self.service = service
        self.paymobService = paymobService
    }

    // MARK: - Shopify order operations

    func getTotalPrice(id: Int) async throws -> PaymentOrder {
        guard let order = try await service.loadDraft(id: id) else {
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

    // MARK: - Paymob payment

    func startPayment(
        request: PaymobPaymentRequest,
        configuration: PaymobConfiguration
    ) async throws -> PaymentResult {
        return try await paymobService.pay(
            request: request,
            configuration: configuration
        )
    }
}
