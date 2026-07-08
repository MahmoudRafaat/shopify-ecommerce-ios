//
//  SendMessageUseCase.swift
//  shopify-ecommerce-ios
//
//  Created by Mahmoud Raafat Mustafa on 07/07/2026.
//

import Foundation

protocol SendMessageUseCaseProtocol {
    func execute(message: String) async throws -> AIResponse
}

class SendMessageUseCase: SendMessageUseCaseProtocol {
    private let repository: ChatRepositoryProtocol

    init(repository: ChatRepositoryProtocol) {
        self.repository = repository
    }

    func execute(message: String) async throws -> AIResponse {
        return try await repository.sendMessage(message)
    }
}
