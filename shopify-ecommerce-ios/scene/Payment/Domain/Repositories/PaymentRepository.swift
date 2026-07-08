//
//  PaymentRepository.swift
//  shopify-ecommerce-ios
//
//  Created by albaraa alsayed on 19/01/1448 AH.
//

import Foundation

protocol PaymentRepo {

    // MARK: - Shopify order operations
    func getTotalPrice(id: Int) async throws -> PaymentOrder
    func completeOrder(id: Int, paymentPending: Bool) async throws

    // MARK: - Paymob payment

    /// Initiates a Paymob payment session.
    ///
    /// The repository does **not** receive a `UIViewController` — SDK
    /// presentation is delegated to the concrete `PaymobService`, which
    /// resolves the topmost view controller itself. This keeps the protocol
    /// free of UIKit and testable with a plain mock.
    ///
    /// - Parameters:
    ///   - request: Domain entity with amount, billing data and line items.
    ///   - configuration: Paymob API credentials.
    /// - Returns: A `PaymentResult` describing the transaction outcome.
    func startPayment(
        request: PaymobPaymentRequest,
        configuration: PaymobConfiguration
    ) async throws -> PaymentResult
}
