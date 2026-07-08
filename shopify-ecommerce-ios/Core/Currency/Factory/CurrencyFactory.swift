//
//  CurrencyFactory.swift
//  shopify-ecommerce-ios
//
//  Created by albaraa alsayed on 22/01/1448 AH.
//


import Foundation

final class CurrencyFactory {
    static func makeGetExchangeRatesUseCase() -> GetExchangeRatesUseCase {
        let remoteDataSource = CurrencyRemoteDataSourceImpl()
        let repository = CurrencyRepositoryImpl(remoteDataSource: remoteDataSource)
        return GetExchangeRatesUseCaseImpl(repository: repository)
    }
}
