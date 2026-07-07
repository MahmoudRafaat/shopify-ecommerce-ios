//
//  CurrencyRepositoryImpl.swift
//  shopify-ecommerce-ios
//
//  Created by albaraa alsayed on 22/01/1448 AH.
//



import Foundation

final class CurrencyRepositoryImpl: CurrencyRepository {
    private let remoteDataSource: CurrencyRemoteDataSource
    
    init(remoteDataSource: CurrencyRemoteDataSource) {
        self.remoteDataSource = remoteDataSource
    }
    
    func getExchangeRates(base: String) async throws -> ExchangeRates {
        let dto = try await remoteDataSource.fetchLatestRates(base: base)
        return dto.toDomain()
    }
}
