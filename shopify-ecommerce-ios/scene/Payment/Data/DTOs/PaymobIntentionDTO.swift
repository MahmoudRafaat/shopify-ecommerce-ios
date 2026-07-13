//
//  PaymobIntentionDTO.swift
//  shopify-ecommerce-ios
//

import Foundation

// MARK: - Request

/// Top-level body sent to POST /v1/intention/
struct PaymobIntentionRequestDTO: Encodable {
    /// Amount in the **smallest currency unit** (e.g. cents for EGP/USD).
    let amount: Int
    let currency: String
    let paymentMethods: [Int]?
    let items: [PaymobItemDTO]
    let billingData: PaymobBillingDataDTO
    let customer: PaymobCustomerDTO
    /// Optional extras forwarded to the payment page.
    let extras: [String: String]?
    let redirectionUrl: String?

    enum CodingKeys: String, CodingKey {
        case amount
        case currency
        case paymentMethods  = "payment_methods"
        case items
        case billingData     = "billing_data"
        case customer
        case extras
        case redirectionUrl  = "redirection_url"
    }
}

struct PaymobItemDTO: Encodable {
    let name: String
    /// Unit amount in smallest currency unit.
    let amount: Int
    let description: String
    let quantity: Int
}

struct PaymobBillingDataDTO: Encodable {
    let firstName: String
    let lastName: String
    let email: String
    let phoneNumber: String
    let apartment: String
    let floor: String
    let street: String
    let building: String
    let shippingMethod: String
    let postalCode: String
    let city: String
    let country: String
    let state: String

    enum CodingKeys: String, CodingKey {
        case firstName      = "first_name"
        case lastName       = "last_name"
        case email
        case phoneNumber    = "phone_number"
        case apartment
        case floor
        case street
        case building
        case shippingMethod = "shipping_method"
        case postalCode     = "postal_code"
        case city
        case country
        case state
    }
}

struct PaymobCustomerDTO: Encodable {
    let firstName: String
    let lastName: String
    let email: String

    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case lastName  = "last_name"
        case email
    }
}

// MARK: - Response

/// Response from POST /v1/intention/
struct PaymobIntentionResponseDTO: Decodable {
    /// The client secret passed to the PaymobSDK to present the payment UI.
    let clientSecret: String

    enum CodingKeys: String, CodingKey {
        case clientSecret = "client_secret"
    }
}
