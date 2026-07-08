//
//  PaymentCoordinator.swift
//  shopify-ecommerce-ios
//

import Foundation

/// Concrete coordinator that owns every infrastructure concern the ViewModel
/// should never see:
///  - Loading `PaymobConfiguration` from the bundle (infrastructure)
///  - Calling `StartPaymentUseCase` with that configuration (orchestration)
///
/// UIKit view controller resolution happens one layer deeper inside
/// `PaymobService`, so this coordinator stays UIKit-free as well.
///
/// ## Responsibilities
/// 1. Load credentials via `PaymobConfiguration.fromBundle()`.
/// 2. Forward the call to `StartPaymentUseCase`.
/// 3. Propagate the `PaymentResult` or error back to the ViewModel.
@MainActor
final class PaymentCoordinator: PaymentFlowCoordinating {

    // MARK: - Dependencies

    private let startPaymentUseCase: StartPaymentUseCase

    // MARK: - Init

    init(startPaymentUseCase: StartPaymentUseCase) {
        self.startPaymentUseCase = startPaymentUseCase
    }

    // MARK: - PaymentFlowCoordinating

    func startPayment(request: PaymobPaymentRequest) async throws -> PaymentResult {
        // Load configuration here — keeps this infrastructure call out of both
        // the ViewModel and the domain use case.
        let configuration = try PaymobConfiguration.fromBundle()

        guard configuration.cardIntegrationID > 0 else {
            throw PaymentCoordinatorError.configurationLoadFailed("PAYMOB_CARD_INTEGRATION_ID is missing or 0 in Info.plist / Secrets.xcconfig.")
        }

        // Populate request with the loaded integration ID from bundle
        let updatedRequest = PaymobPaymentRequest(
            amountCents: request.amountCents,
            currency: request.currency,
            paymentMethodIDs: [configuration.cardIntegrationID],
            billingData: request.billingData,
            items: request.items,
            extras: request.extras
        )

        return try await startPaymentUseCase.execute(
            request: updatedRequest,
            configuration: configuration
        )
    }
}

// MARK: - Coordinator errors

enum PaymentCoordinatorError: LocalizedError {
    case configurationLoadFailed(String)

    var errorDescription: String? {
        switch self {
        case .configurationLoadFailed(let reason):
            return "Payment coordinator could not load configuration: \(reason)"
        }
    }
}
