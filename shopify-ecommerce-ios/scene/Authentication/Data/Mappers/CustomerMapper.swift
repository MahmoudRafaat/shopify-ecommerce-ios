//
//  CustomerMapper.swift
//  shopify-ecommerce-ios
//
//  Created by Albaraa Alsayed on 08/07/2026.
//

import Foundation

final class CustomerMapper {
    static func map(from response: CustomerOutput) -> Customer {
        return Customer(
            id: response.id ?? 0,
            email: response.email ?? "",
            firstName: response.firstName ?? "",
            lastName: response.lastName ?? "",
            phone: response.phone ?? "",
            currency: response.currency ?? "USD",
            addresses: response.addresses?.compactMap { map(from: $0) } ?? [],
            defaultAddress: response.defaultAddress.flatMap { map(from: $0) }
        )
    }
    
    static func map(from response: AddressOutput) -> Address {
        return Address(
            id: response.id ?? 0,
            customerId: response.customerId ?? 0,
            province: response.province ?? "",
            country: response.country ?? "",
            provinceCode: response.provinceCode ?? "",
            countryCode: response.countryCode ?? "",
            countryName: response.countryName ?? "",
            isDefault: response.default ?? false
        )
    }
}
