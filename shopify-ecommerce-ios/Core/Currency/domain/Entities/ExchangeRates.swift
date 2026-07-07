//
//  ExchangeRates.swift
//  shopify-ecommerce-ios
//
//  Created by albaraa alsayed on 22/01/1448 AH.
//



import Foundation

struct ExchangeRates {
    let baseCode: String
    let timeNextUpdateUnix: Int
    let rates: [String: Double]
}
