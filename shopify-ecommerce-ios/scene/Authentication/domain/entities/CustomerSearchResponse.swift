//
//  CustomerSearchResponse.swift
//  shopify-ecommerce-ios
//
//  Created by Mahmoud Raafat Mustafa on 30/06/2026.
//

import Foundation

struct CustomerSearchResponse: Decodable {
    let customers: [CustomerOutput]
}

