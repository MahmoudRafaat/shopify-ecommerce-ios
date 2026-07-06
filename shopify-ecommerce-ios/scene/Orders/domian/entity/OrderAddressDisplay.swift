//
//  OrderAddressDisplay.swift
//  shopify-ecommerce-ios
//
//  Created by Mahmoud Raafat Mustafa on 06/07/2026.
//

import Foundation

struct OrderAddressDisplay: Hashable {  
    let address1: String?
    let address2: String?
    let city: String?
    let province: String?
    let provinceCode: String?
    let country: String?
    let countryCode: String?
    let zip: String?
    let firstName: String?
    let lastName: String?
    let phone: String?
    
    var fullName: String {
        [firstName, lastName]
            .compactMap { $0 }
            .filter { !$0.isEmpty }
            .joined(separator: " ")
    }
    
    var formattedAddress: String {
        let components = [
            address1,
            address2,
            city,
            province,
            zip
        ]
        .compactMap { $0 }
        .filter { !$0.isEmpty }
        
        return components.joined(separator: "\n")
    }
    
    var hasValidAddress: Bool {
        let hasAddressLine = address1?.isEmpty == false
        let hasCity = city?.isEmpty == false
        let hasProvince = province?.isEmpty == false || provinceCode?.isEmpty == false
        let hasZip = zip?.isEmpty == false
        return hasAddressLine && hasCity && hasProvince && hasZip
    }
    
    init(from dto: OrderAddressDTO) {
        self.address1 = dto.address1
        self.address2 = dto.address2
        self.city = dto.city
        self.province = dto.province
        self.provinceCode = dto.provinceCode
        self.country = dto.country
        self.countryCode = dto.countryCode
        self.zip = dto.zip
        self.firstName = dto.firstName
        self.lastName = dto.lastName
        self.phone = dto.phone
    }
}
