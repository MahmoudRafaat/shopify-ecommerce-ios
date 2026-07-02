//
//  CustomerRequest.swift
//  shopify-ecommerce-ios
//
//  Created by Ehab Salah on 30/06/2026.
//

import Foundation

struct CustomerRequest: Encodable {
    let customer: CustomerInput

    static var shopifyEncoder: JSONEncoder {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        return encoder
    }
}

struct CustomerInput: Encodable {
    let firstName: String
    let lastName: String
    let email: String
    let phone: String?          // nil → field is omitted from JSON
    let verifiedEmail: Bool = true
    let addresses: [AddressInput]
}

struct AddressInput: Encodable {
    let address1: String
    let city: String
    let province: String
    let phone: String?          // nil → field is omitted from JSON
    let zip: String
    let country: String
}
