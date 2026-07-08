//
//  PaymobConfiguration.swift
//  shopify-ecommerce-ios
//

import Foundation

/// Holds Paymob API credentials injected via Secrets.xcconfig → Info.plist.
/// Do NOT hard-code values here. Replace the dummy strings in Secrets.xcconfig
/// with your real Paymob credentials before going to production.
struct PaymobConfiguration {

    /// Your Paymob Public Key (used by the SDK to present the payment UI).
    let publicKey: String

    /// Your Paymob Secret Key (used server-side to create a payment intention).
    let secretKey: String

    /// Your Paymob Card Integration ID.
    let cardIntegrationID: Int

    /// Base URL for Paymob's Acceptance API v1.
    let baseURL: URL

    /// Builds configuration by reading from SecretConstants.
    /// - Throws: `PaymobConfigurationError.invalidBaseURL` if the URL is invalid.
    static func fromBundle() throws -> PaymobConfiguration {
        guard let url = URL(string: "https://accept.paymob.com/v1") else {
            throw PaymobConfigurationError.invalidBaseURL
        }
        print("[PaymobConfiguration] Loaded Public Key: \(SecretConstants.paymobPublicKey), Card ID: \(SecretConstants.paymobCardIntegrationID)")
        return PaymobConfiguration(
            publicKey: SecretConstants.paymobPublicKey,
            secretKey: SecretConstants.paymobSecretKey,
            cardIntegrationID: SecretConstants.paymobCardIntegrationID,
            baseURL: url
        )
    }
}

// MARK: - Errors

enum PaymobConfigurationError: LocalizedError {
    case missingKey(String)
    case invalidBaseURL

    var errorDescription: String? {
        switch self {
        case .missingKey(let key):
            return "Paymob configuration error: '\(key)' is missing from Info.plist. " +
                   "Add it to Secrets.xcconfig and map it in Info.plist."
        case .invalidBaseURL:
            return "Paymob configuration error: invalid base URL."
        }
    }
}
