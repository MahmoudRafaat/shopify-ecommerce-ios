//
//  UpdateCustomerRequest.swift
//  shopify-ecommerce-ios
//
//  Created by Mahmoud Raafat Mustafa on 04/07/2026.
//



struct UpdateCustomerRequest: Codable {
    let customer: Customer
    
    struct Customer: Codable {
        let addresses: [Address]
    }
    
    struct Address: Codable {
        let id: Int?
        let address1: String
        let city: String
        let province: String
        let country: String
        let zip: String
        let phone: String?
        let firstName: String
        let lastName: String
        let isDefault: Bool

        enum CodingKeys: String, CodingKey {
            case id
            case address1, city, province, country, zip, phone
            case firstName = "first_name"
            case lastName = "last_name"
            case isDefault = "default"
        }
    }
}
