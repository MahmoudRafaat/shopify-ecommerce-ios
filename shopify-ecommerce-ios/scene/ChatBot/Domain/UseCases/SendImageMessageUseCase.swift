//
//  SendImageMessageUseCase.swift
//  shopify-ecommerce-ios
//
//  Created by Mahmoud Raafat Mustafa on 07/07/2026.
//

import Foundation
import UIKit

protocol SendImageMessageUseCaseProtocol {
    func execute(image: UIImage, message: String?) async throws -> AIResponse
}

class SendImageMessageUseCase: SendImageMessageUseCaseProtocol {
    private let repository: ChatRepositoryProtocol

    init(repository: ChatRepositoryProtocol) {
        self.repository = repository
    }

    func execute(image: UIImage, message: String?) async throws -> AIResponse {
        return try await repository.sendMessageWithImage(image, message: message)
    }
}
