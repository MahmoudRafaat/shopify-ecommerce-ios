//
//  ProfileModels.swift
//  shopify-ecommerce-ios
//
//  Created by Mahmoud Raafat Mustafa on 04/07/2026.
//

import Foundation

// MARK: - Domain Models

struct ProfileAddress {
    let id: Int?
    let address1: String
    let city: String
    let province: String
    let country: String
    let zip: String
    let phone: String?
    let firstName: String?
    let lastName: String?
    let isDefault: Bool
}

/// ⚠️ SECURITY WARNING: Storing raw card data (cardNumber, cvv) in Shopify metafields
/// is NOT PCI-compliant and must NEVER be used in a production app.
/// This is for learning/dummy purposes only. In production, use a tokenized
/// payment processor (Stripe, Shopify Payments, etc.) and store only the token.
struct PaymentDetails: Codable {
    let cardholderName: String
    let cardNumber: String    // ⚠️ DUMMY ONLY — production must use tokens
    let expiryMonth: String
    let expiryYear: String
    let cvv: String          // ⚠️ DUMMY ONLY — production must use tokens
    let isDefault: Bool
    
    var lastFourDigits: String {
        guard cardNumber.count >= 4 else { return "" }
        return String(cardNumber.suffix(4))
    }
}

struct ProfileDisplayModel {
    let email: String
    var firstName: String
    var lastName: String
    var address: ProfileAddress?
    var paymentDetails: PaymentDetails?
    
    var hasDefaultAddress: Bool { address != nil }
    var hasPaymentDetails: Bool { paymentDetails != nil }
}