//
//  CurrencyRepositoryImpl.swift
//  shopify-ecommerce-ios
//

import Foundation

final class CurrencyRepositoryImpl: CurrencyRepository {
    private let remoteDataSource: CurrencyRemoteDataSource
    
    init(remoteDataSource: CurrencyRemoteDataSource) {
        self.remoteDataSource = remoteDataSource
    }
    
    func getExchangeRates(base: String) async throws -> ExchangeRates {
        return try await remoteDataSource.fetchLatestRates(base: base)
    }
}
