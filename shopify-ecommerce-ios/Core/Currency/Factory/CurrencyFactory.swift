//
//  CurrencyFactory.swift
//  shopify-ecommerce-ios
//

import Foundation

final class CurrencyFactory {
    static func makeGetExchangeRatesUseCase() -> GetExchangeRatesUseCase {
        let remoteDataSource = CurrencyRemoteDataSourceImpl()
        let repository = CurrencyRepositoryImpl(remoteDataSource: remoteDataSource)
        return GetExchangeRatesUseCaseImpl(repository: repository)
    }
}
