//
//  PaymobService.swift
//  shopify-ecommerce-ios
//

import Foundation
import UIKit
import PaymobSDK

// MARK: - Protocol

/// Abstracts all interaction with the Paymob SDK and Paymob's REST API.
///
/// `UIViewController` is intentionally absent from this protocol's surface.
/// The concrete implementation resolves the topmost view controller itself,
/// which means callers — repository, use case, coordinator — never need to
/// import UIKit to call `pay(request:configuration:)`.
protocol PaymobServiceProtocol: AnyObject {
    /// Fetches a client_secret from Paymob's intention API, then presents
    /// the native payment sheet over the current topmost view controller.
    /// - Returns: A `PaymentResult` reflecting the user's outcome.
    func pay(
        request: PaymobPaymentRequest,
        configuration: PaymobConfiguration
    ) async throws -> PaymentResult
}

// MARK: - Implementation

/// Concrete service that:
///  1. Encodes the intention body and POSTs to `https://accept.paymob.com/v1/intention/`.
///  2. Resolves the topmost `UIViewController` at call time.
///  3. Passes the returned `client_secret` + `publicKey` to `PaymobSDK.presentPayVC`.
///  4. Bridges the SDK delegate callbacks back into a `CheckedContinuation` so callers
///     can await the outcome without dealing with callbacks.
@MainActor
final class PaymobService: NSObject, PaymobServiceProtocol, PaymobSDKDelegate {

    // MARK: - Private state

    /// Held alive for the duration of a single payment session.
    private var sdk: PaymobSDK?
    /// Bridge between the SDK delegate and async/await callers.
    private var continuation: CheckedContinuation<PaymentResult, Error>?
    /// The view controller that presented the Paymob SDK payment sheet.
    private weak var presentingVC: UIViewController?

    // MARK: - PaymobServiceProtocol

    func pay(
        request: PaymobPaymentRequest,
        configuration: PaymobConfiguration
    ) async throws -> PaymentResult {

        // Step 1 – Create payment intention and obtain client_secret.
        let clientSecret = try await createIntention(
            request: request,
            configuration: configuration
        )

        // Step 2 – Resolve the topmost view controller at call time.
        guard let presentingVC = UIApplication.shared.topmostViewController() else {
            throw PaymobError.noViewControllerAvailable
        }
        self.presentingVC = presentingVC

        // Step 3 – Present the Paymob payment sheet and await the delegate callback.
        return try await withCheckedThrowingContinuation { continuation in
            self.continuation = continuation

            let sdk = PaymobSDK()
            sdk.delegate = self
            sdk.paymobSDKCustomization.showConfirmationPage = true
            sdk.paymobSDKCustomization.showTransactionResult = false
            self.sdk = sdk

            do {
                try sdk.presentPayVC(
                    VC: presentingVC,
                    PublicKey: configuration.publicKey,
                    ClientSecret: clientSecret
                )
            } catch {
                self.continuation = nil
                self.presentingVC = nil
                continuation.resume(throwing: PaymobError.sdkPresentationFailed(error.localizedDescription))
            }
        }
    }

    // MARK: - PaymobSDKDelegate

    nonisolated func transactionAccepted(transactionDetails: [String: Any]) {
        Task { @MainActor in
            print("[PaymobService] transactionAccepted. Details: \(transactionDetails)")
            let continuation = self.continuation
            let presentingVC = self.presentingVC
            self.tearDown()
            
            if let presentingVC = presentingVC, presentingVC.presentedViewController != nil {
                presentingVC.dismiss(animated: true) {
                    continuation?.resume(returning: .success(transactionDetails: transactionDetails))
                }
            } else {
                continuation?.resume(returning: .success(transactionDetails: transactionDetails))
            }
        }
    }

    nonisolated func transactionRejected(message: String) {
        Task { @MainActor in
            print("[PaymobService] transactionRejected. Message: '\(message)'")
            let continuation = self.continuation
            let presentingVC = self.presentingVC
            self.tearDown()
            
            let reason = message.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                ? "The transaction was declined or cancelled."
                : message
                
            if let presentingVC = presentingVC, presentingVC.presentedViewController != nil {
                presentingVC.dismiss(animated: true) {
                    continuation?.resume(returning: .failure(reason: reason))
                }
            } else {
                continuation?.resume(returning: .failure(reason: reason))
            }
        }
    }

    nonisolated func transactionPending() {
        Task { @MainActor in
            print("[PaymobService] transactionPending")
            let continuation = self.continuation
            let presentingVC = self.presentingVC
            self.tearDown()
            
            if let presentingVC = presentingVC, presentingVC.presentedViewController != nil {
                presentingVC.dismiss(animated: true) {
                    continuation?.resume(returning: .pending)
                }
            } else {
                continuation?.resume(returning: .pending)
            }
        }
    }

    // MARK: - Private helpers

    /// Builds the intention request body, POSTs it to Paymob's REST API, and
    /// returns the `client_secret` string required to initialise the payment sheet.
    private func createIntention(
        request: PaymobPaymentRequest,
        configuration: PaymobConfiguration
    ) async throws -> String {

        let dto = PaymobIntentionRequestDTO(
            amount: request.amountCents,
            currency: request.currency,
            paymentMethods: request.paymentMethodIDs.isEmpty ? nil : request.paymentMethodIDs,
            items: request.items.map {
                PaymobItemDTO(
                    name: $0.name,
                    amount: $0.amountCents,
                    description: $0.itemDescription,
                    quantity: $0.quantity
                )
            },
            billingData: PaymobBillingDataDTO(
                firstName: request.billingData.firstName,
                lastName: request.billingData.lastName,
                email: request.billingData.email,
                phoneNumber: request.billingData.phoneNumber,
                apartment: request.billingData.apartment,
                floor: request.billingData.floor,
                street: request.billingData.street,
                building: request.billingData.building,
                shippingMethod: request.billingData.shippingMethod,
                postalCode: request.billingData.postalCode,
                city: request.billingData.city,
                country: request.billingData.country,
                state: request.billingData.state
            ),
            customer: PaymobCustomerDTO(
                firstName: request.billingData.firstName,
                lastName: request.billingData.lastName,
                email: request.billingData.email
            ),
            extras: request.extras,
            redirectionUrl: "https://accept.paymob.com/api/acceptance/post_pay"
        )

        let bodyData = try JSONEncoder().encode(dto)
        let endpoint = PaymobEndPoint.createIntention(body: bodyData, secretKey: configuration.secretKey)

        guard let url = URL(string: endpoint.urlString) else {
            throw PaymobError.invalidURL
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = endpoint.method.rawValue
        urlRequest.httpBody = endpoint.body
        for (name, value) in endpoint.headers.dictionary {
            urlRequest.setValue(value, forHTTPHeaderField: name)
        }

        let (data, response) = try await URLSession.shared.data(for: urlRequest)

        if let httpResponse = response as? HTTPURLResponse {
            let status = httpResponse.statusCode
            guard (200..<300).contains(status) else {
                let message = String(data: data, encoding: .utf8) ?? "Unknown error"
                print("[PaymobService] Intention API error \(status): \(message)")
                throw PaymobError.intentionAPIError(statusCode: status, message: message)
            }
        }

        let responseDTO = try JSONDecoder().decode(PaymobIntentionResponseDTO.self, from: data)
        return responseDTO.clientSecret
    }

    /// Releases the SDK instance and clears the in-flight continuation.
    private func tearDown() {
        continuation = nil
        sdk = nil
        presentingVC = nil
    }
}

// MARK: - Domain-facing errors

enum PaymobError: LocalizedError {
    case noViewControllerAvailable
    case configurationError(String)
    case invalidURL
    case intentionAPIError(statusCode: Int, message: String)
    case sdkPresentationFailed(String)

    var errorDescription: String? {
        switch self {
        case .noViewControllerAvailable:
            return "Paymob: No view controller is available to present the payment screen."
        case .configurationError(let msg):
            return "Paymob configuration error: \(msg)"
        case .invalidURL:
            return "Paymob: Could not build a valid request URL."
        case .intentionAPIError(let code, let msg):
            return "Paymob intention API returned \(code): \(msg)"
        case .sdkPresentationFailed(let msg):
            return "Paymob SDK failed to present payment screen: \(msg)"
        }
    }
}
