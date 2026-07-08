//
//  ExchangeRatesDTO.swift
//  shopify-ecommerce-ios
//
//  Created by albaraa alsayed on 22/01/1448 AH.
//



import Foundation

struct ExchangeRatesDTO: Codable {
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
    
    func toDomain() -> ExchangeRates {
        return ExchangeRates(
            baseCode: baseCode,
            timeNextUpdateUnix: timeNextUpdateUnix,
            rates: rates
        )
    }
}
