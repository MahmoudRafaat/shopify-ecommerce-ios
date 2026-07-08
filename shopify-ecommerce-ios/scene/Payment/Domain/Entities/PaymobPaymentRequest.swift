//
//  PaymobPaymentRequest.swift
//  shopify-ecommerce-ios
//

import Foundation

// MARK: - PaymobPaymentRequest

/// Domain entity that encapsulates everything needed to initiate a Paymob payment.
/// This is the value the use case receives from the ViewModel — it is pure Swift and
/// has no dependency on the Paymob SDK or any networking type.
struct PaymobPaymentRequest {
    /// Total amount in the **smallest currency unit** (e.g. 10000 = 100.00 EGP).
    let amountCents: Int
    /// ISO-4217 currency code, e.g. "EGP" or "USD".
    let currency: String
    /// Paymob integration IDs that determine which payment methods are offered.
    let paymentMethodIDs: [Int]
    /// Customer billing information.
    let billingData: PaymobBillingData
    /// Line items in the order.
    let items: [PaymobOrderItem]
    /// Optional key-value pairs forwarded as extras to the payment intention.
    let extras: [String: String]?
}

// MARK: - PaymobBillingData

/// Customer billing and shipping information required by Paymob.
struct PaymobBillingData {
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

    /// Convenience initialiser with sensible defaults for optional address fields.
    init(
        firstName: String,
        lastName: String,
        email: String,
        phoneNumber: String,
        apartment: String = "N/A",
        floor: String = "N/A",
        street: String = "N/A",
        building: String = "N/A",
        shippingMethod: String = "PKG",
        postalCode: String = "N/A",
        city: String = "N/A",
        country: String = "EG",
        state: String = "N/A"
    ) {
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.phoneNumber = phoneNumber
        self.apartment = apartment
        self.floor = floor
        self.street = street
        self.building = building
        self.shippingMethod = shippingMethod
        self.postalCode = postalCode
        self.city = city
        self.country = country
        self.state = state
    }
}

// MARK: - PaymobOrderItem

/// A single line item passed to the Paymob intention API.
struct PaymobOrderItem {
    let name: String
    /// Unit amount in smallest currency unit.
    let amountCents: Int
    let itemDescription: String
    let quantity: Int
}
