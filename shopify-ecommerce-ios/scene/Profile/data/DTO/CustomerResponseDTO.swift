//
//  CustomerResponse.swift
//  shopify-ecommerce-ios
//
//  Created by Mahmoud Raafat Mustafa on 04/07/2026.
//



struct CustomerResponseDTO: Codable {
    let customer: CustomerDTO
}
struct CustomerDTO: Codable {
    let id: Int
    let email: String?
    let firstName: String?
    let lastName: String?
    let addresses: [AddressDTO]?
    let defaultAddress: AddressDTO?
    
    enum CodingKeys: String, CodingKey {
        case id
        case email
        case firstName = "first_name"
        case lastName = "last_name"
        case addresses
        case defaultAddress = "default_address"
    }
}
struct AddressDTO: Codable {
    let id: Int?
    let address1: String?
    let address2: String?
    let city: String?
    let province: String?
    let country: String?
    let zip: String?
    let phone: String?
    let firstName: String?
    let lastName: String?
    let isDefault: Bool?
    let provinceCode: String?
    let countryCode: String?
    let countryName: String?
    
    enum CodingKeys: String, CodingKey {
        case id, address1, address2, city, province, country, zip, phone
        case firstName = "first_name"
        case lastName = "last_name"
        case isDefault = "default"
        case provinceCode = "province_code"
        case countryCode = "country_code"
        case countryName = "country_name"
    }
}
