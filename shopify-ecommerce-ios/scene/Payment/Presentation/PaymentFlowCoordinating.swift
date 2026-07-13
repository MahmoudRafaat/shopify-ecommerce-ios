//
//  PaymentFlowCoordinating.swift
//  shopify-ecommerce-ios
//

import Foundation

/// The contract the ViewModel uses to trigger a Paymob payment flow.
///
/// Keeping this as a protocol means the ViewModel has **zero** UIKit imports —
/// the concrete coordinator that conforms to it is wired up by the factory,
/// never referenced directly in the ViewModel.
///
/// This also makes the ViewModel trivially testable: swap in a mock coordinator
/// that immediately returns a `.success` result without presenting any UI.
protocol PaymentFlowCoordinating: AnyObject {
    /// Builds the payment request and runs the full Paymob session.
    /// Returns a `PaymentResult` when the session completes (success, failure, or pending).
    func startPayment(request: PaymobPaymentRequest) async throws -> PaymentResult
}
