//
//  CurrencyRepository.swift
//  shopify-ecommerce-ios
//

import Foundation

protocol CurrencyRepository {
    func getExchangeRates(base: String) async throws -> ExchangeRates
}
