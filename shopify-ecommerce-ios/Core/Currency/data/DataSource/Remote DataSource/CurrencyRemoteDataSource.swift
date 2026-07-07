//
//  CurrencyRemoteDataSource.swift
//  shopify-ecommerce-ios
//
//  Created by albaraa alsayed on 22/01/1448 AH.
//



import Foundation

protocol CurrencyRemoteDataSource {
    func fetchLatestRates(base: String) async throws -> ExchangeRatesDTO
}

final class CurrencyRemoteDataSourceImpl: CurrencyRemoteDataSource {
    func fetchLatestRates(base: String) async throws -> ExchangeRatesDTO {
        return try await NetworkService.request(endpoint: CurrencyEndpoint.latestRates(base: base))
    }
}
