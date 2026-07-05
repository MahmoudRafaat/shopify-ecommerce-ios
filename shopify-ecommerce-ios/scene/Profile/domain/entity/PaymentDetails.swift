//
//  PaymentDetails.swift
//  shopify-ecommerce-ios
//
//  Created by Mahmoud Raafat Mustafa on 04/07/2026.
//


struct PaymentDetails: Codable {
    let cardholderName: String
    let cardNumber: String
    let expiryMonth: String
    let expiryYear: String
    let cvv: String
    let isDefault: Bool
    var lastFourDigits: String {
        guard cardNumber.count >= 4 else { return "" }
        return String(cardNumber.suffix(4))
    }
}