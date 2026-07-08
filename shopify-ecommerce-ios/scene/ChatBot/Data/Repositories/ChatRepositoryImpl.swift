//
//  ChatRepositoryImpl.swift
//  shopify-ecommerce-ios
//
//  Created by Mahmoud Raafat Mustafa on 07/07/2026.
//

import Foundation
import UIKit

class ChatRepositoryImpl: ChatRepositoryProtocol {
    private let remoteDataSource: ChatRemoteDataSourceProtocol

    init(remoteDataSource: ChatRemoteDataSourceProtocol) {
        self.remoteDataSource = remoteDataSource
    }

    func sendMessage(_ message: String) async throws -> AIResponse {
        return try await remoteDataSource.sendMessage(message)
    }

    func sendMessageWithImage(_ image: UIImage, message: String?) async throws -> AIResponse {
        return try await remoteDataSource.sendMessageWithImage(image, message: message)
    }

    func compareProducts(_ product1: Product, _ product2: Product) async throws -> AIResponse {
        return try await remoteDataSource.compareProducts(product1, product2)
    }

    func getOverallSuggestions() async throws -> AIResponse {
        return try await remoteDataSource.getOverallSuggestions()
    }
}
