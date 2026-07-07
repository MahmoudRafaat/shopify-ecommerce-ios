//
//  CurrencyRepository.swift
//  shopify-ecommerce-ios
//
//  Created by albaraa alsayed on 22/01/1448 AH.
//



import Foundation

protocol CurrencyRepository {
    func getExchangeRates(base: String) async throws -> ExchangeRates
}
