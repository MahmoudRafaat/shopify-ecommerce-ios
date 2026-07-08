//
//  GetSuggestionsUseCase.swift
//  shopify-ecommerce-ios
//
//  Created by Mahmoud Raafat Mustafa on 07/07/2026.
//

import Foundation

protocol GetSuggestionsUseCaseProtocol {
    func execute() async throws -> AIResponse
}

class GetSuggestionsUseCase: GetSuggestionsUseCaseProtocol {
    private let repository: ChatRepositoryProtocol

    init(repository: ChatRepositoryProtocol) {
        self.repository = repository
    }

    func execute() async throws -> AIResponse {
        return try await repository.getOverallSuggestions()
    }
}
