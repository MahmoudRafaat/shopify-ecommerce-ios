//
//  Customer.swift
//  shopify-ecommerce-ios
//
//  Created by Albaraa Alsayed on 08/07/2026.
//

import Foundation

/// Pure Domain Entity representing a customer.
/// Stripped of all API specifics and `Decodable` annotations.
struct Customer {
    let id: Int
    let email: String
    let firstName: String
    let lastName: String
    let phone: String
    let currency: String
    let addresses: [Address]
    let defaultAddress: Address?
}

struct Address {
    let id: Int
    let customerId: Int
    let province: String
    let country: String
    let provinceCode: String
    let countryCode: String
    let countryName: String
    let isDefault: Bool
}
