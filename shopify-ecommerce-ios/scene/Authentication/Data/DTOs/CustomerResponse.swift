//
//  CustomerResponse.swift
//  shopify-ecommerce-ios
//
//  Created by Ehab Salah on 30/06/2026.
//

import Foundation

struct CustomerResponse: Decodable {
    let customer: CustomerOutput
}

struct CustomerOutput: Decodable {
    let id: Int?
    let email: String?
    let firstName: String?
    let lastName: String?
    let phone: String?
    let createdAt: String?
    let updatedAt: String?
    let ordersCount: Int?
    let state: String?
    let totalSpent: String?
    let verifiedEmail: Bool?
    let currency: String?
    let addresses: [AddressOutput]?
    let defaultAddress: AddressOutput?

    enum CodingKeys: String, CodingKey {
        case id
        case email
        case firstName = "first_name"
        case lastName = "last_name"
        case phone
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case ordersCount = "orders_count"
        case state
        case totalSpent = "total_spent"
        case verifiedEmail = "verified_email"
        case currency
        case addresses
        case defaultAddress = "default_address"
    }
}

struct AddressOutput: Decodable {
    let id: Int?
    let customerId: Int?
    let province: String?
    let country: String?
    let provinceCode: String?
    let countryCode: String?
    let countryName: String?
    let `default`: Bool?

    enum CodingKeys: String, CodingKey {
        case id
        case customerId = "customer_id"
        case province
        case country
        case provinceCode = "province_code"
        case countryCode = "country_code"
        case countryName = "country_name"
        case `default`
    }
}
