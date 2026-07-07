//
//  CurrencyRemoteDataSource.swift
//  shopify-ecommerce-ios
//

import Foundation

protocol CurrencyRemoteDataSource {
    func fetchLatestRates(base: String) async throws -> ExchangeRates
}

final class CurrencyRemoteDataSourceImpl: CurrencyRemoteDataSource {
    func fetchLatestRates(base: String) async throws -> ExchangeRates {
        return try await NetworkService.request(endpoint: CurrencyEndpoint.latestRates(base: base))
    }
}
