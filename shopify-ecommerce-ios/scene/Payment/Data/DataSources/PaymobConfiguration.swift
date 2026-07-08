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

    /// Builds configuration by reading from the main bundle's Info.plist.
    /// - Throws: `PaymobConfigurationError.missingKey` if a required key is absent.
    static func fromBundle() throws -> PaymobConfiguration {
        let dict = Bundle.main.infoDictionary ?? [:]
        guard let publicKey = dict["PAYMOB_PUBLIC_KEY"] as? String, !publicKey.isEmpty else {
            throw PaymobConfigurationError.missingKey("PAYMOB_PUBLIC_KEY")
        }
        guard let secretKey = dict["PAYMOB_SECRET_KEY"] as? String, !secretKey.isEmpty else {
            throw PaymobConfigurationError.missingKey("PAYMOB_SECRET_KEY")
        }
        let idString = dict["PAYMOB_CARD_INTEGRATION_ID"] as? String ?? ""
        let cardIntegrationID = Int(idString) ?? 0
        guard let url = URL(string: "https://accept.paymob.com/v1") else {
            throw PaymobConfigurationError.invalidBaseURL
        }
        print("[PaymobConfiguration] Loaded Public Key: \(publicKey), Card ID: \(cardIntegrationID)")
        return PaymobConfiguration(publicKey: publicKey, secretKey: secretKey, cardIntegrationID: cardIntegrationID, baseURL: url)
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
