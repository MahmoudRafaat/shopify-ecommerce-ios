//
//  ExchangeRates.swift
//  shopify-ecommerce-ios
//

import Foundation

struct ExchangeRates: Codable {
    let result: String
    let baseCode: String
    let timeLastUpdateUnix: Int
    let timeNextUpdateUnix: Int
    let rates: [String: Double]
    
    enum CodingKeys: String, CodingKey {
        case result
        case baseCode = "base_code"
        case timeLastUpdateUnix = "time_last_update_unix"
        case timeNextUpdateUnix = "time_next_update_unix"
        case rates
    }
}
