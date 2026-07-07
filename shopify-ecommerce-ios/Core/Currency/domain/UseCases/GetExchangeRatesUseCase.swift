//
//  GetExchangeRatesUseCase.swift
//  shopify-ecommerce-ios
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
