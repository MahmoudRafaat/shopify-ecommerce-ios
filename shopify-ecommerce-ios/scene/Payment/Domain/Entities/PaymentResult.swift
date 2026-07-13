//
//  PaymentResult.swift
//  shopify-ecommerce-ios
//

import Foundation

/// The outcome of a Paymob payment session.
/// Returned by `StartPaymentUseCase.execute(...)` and observed by the ViewModel.
enum PaymentResult {
    /// The transaction was accepted by the payment gateway.
    /// `transactionDetails` contains the raw key-value pairs returned by the SDK
    /// (e.g. transaction ID, masked card number, amount).
    case success(transactionDetails: [String: Any])

    /// The transaction was declined or an error occurred.
    /// `reason` is a human-readable message suitable for display.
    case failure(reason: String)

    /// The transaction could not be confirmed in real time (e.g. pending bank verification).
    case pending
}

// MARK: - Convenience helpers

extension PaymentResult {
    /// Returns `true` when the transaction was accepted.
    var isSuccess: Bool {
        if case .success = self { return true }
        return false
    }

    /// Returns the failure reason, or `nil` for other cases.
    var failureReason: String? {
        if case .failure(let reason) = self { return reason }
        return nil
    }
}
