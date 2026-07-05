//
//  ProfileAddress.swift
//  shopify-ecommerce-ios
//
//  Created by Mahmoud Raafat Mustafa on 04/07/2026.
//

struct ProfileAddress {
    let id: Int?
    let address1: String
    let address2: String?
    let city: String
    let province: String
    let provinceCode: String
    let country: String
    let countryCode: String
    let zip: String
    let phone: String?
    let firstName: String?
    let lastName: String?
    let isDefault: Bool
    
    init(from dto: AddressDTO) {
        self.id = dto.id
        self.address1 = dto.address1 ?? ""
        self.address2 = dto.address2
        self.city = dto.city ?? ""
        self.province = dto.province ?? ""
        self.provinceCode = dto.provinceCode ?? ""
        self.country = dto.country ?? ""
        self.countryCode = dto.countryCode ?? ""    
        self.zip = dto.zip ?? ""
        self.phone = dto.phone
        self.firstName = dto.firstName
        self.lastName = dto.lastName
        self.isDefault = dto.isDefault ?? false
    }
    
    init(id: Int?, address1: String, address2: String? = nil, city: String, province: String, provinceCode: String = "", country: String, countryCode: String = "", zip: String, phone: String?, firstName: String?, lastName: String?, isDefault: Bool) {
        self.id = id
        self.address1 = address1
        self.address2 = address2
        self.city = city
        self.province = province
        self.provinceCode = provinceCode
        self.country = country
        self.countryCode = countryCode
        self.zip = zip
        self.phone = phone
        self.firstName = firstName
        self.lastName = lastName
        self.isDefault = isDefault
    }
}
