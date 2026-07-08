//
//  StartPaymentUseCase.swift
//  shopify-ecommerce-ios
//

import Foundation

// MARK: - Protocol

/// Encapsulates the business rule for initiating a Paymob payment session.
///
/// The use case is intentionally free of UIKit — it knows nothing about
/// view controllers or SDK presentation. Those responsibilities belong to
/// the coordinator that calls this use case.
protocol StartPaymentUseCase {
    /// - Parameters:
    ///   - request: All data required to create a Paymob payment intention.
    ///   - configuration: Paymob API credentials.
    /// - Returns: A `PaymentResult` describing the transaction outcome.
    func execute(
        request: PaymobPaymentRequest,
        configuration: PaymobConfiguration
    ) async throws -> PaymentResult
}

// MARK: - Implementation

final class StartPaymentUseCaseImp: StartPaymentUseCase {
    private let repository: PaymentRepo

    init(repository: PaymentRepo) {
        self.repository = repository
    }

    func execute(
        request: PaymobPaymentRequest,
        configuration: PaymobConfiguration
    ) async throws -> PaymentResult {
        return try await repository.startPayment(
            request: request,
            configuration: configuration
        )
    }
}
