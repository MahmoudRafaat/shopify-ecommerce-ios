//
//  CustomerRequest.swift
//  shopify-ecommerce-ios
//
//  Created by Ehab Salah on 30/06/2026.
//

import Foundation

struct CustomerRequest: Encodable {
    let customer: CustomerInput
}

struct CustomerInput: Encodable {
    var firstName: String? = nil
    var lastName: String? = nil
    var email: String
    var phone: String
    var verifiedEmail: Bool = true
    var addresses: [AddressInput]? = nil
    
    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case lastName = "last_name"
        case email
        case phone
        case verifiedEmail = "verified_email"
        case addresses
    }
}

struct AddressInput: Encodable {
    let address1: String
    let city: String
    let province: String
    let phone: String
    let zip: String
    let country: String
}
