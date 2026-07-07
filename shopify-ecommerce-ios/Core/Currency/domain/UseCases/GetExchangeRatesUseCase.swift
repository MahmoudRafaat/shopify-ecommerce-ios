//
//  GetExchangeRatesUseCase.swift
//  shopify-ecommerce-ios
//
//  Created by albaraa alsayed on 22/01/1448 AH.
//

import Foundation

protocol GetExchangeRatesUseCase {
    func execute(base: String) async throws -> ExchangeRates
}

final class GetExchangeRatesUseCaseImpl: GetExchangeRatesUseCase {
    private let repository: CurrencyRepository
    
    init(repository: CurrencyRepository) {
        self.repository = repository
    }
    
    func execute(base: String) async throws -> ExchangeRates {
        return try await repository.getExchangeRates(base: base)
    }
}
