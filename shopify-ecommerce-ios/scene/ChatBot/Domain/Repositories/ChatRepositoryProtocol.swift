//
//  ChatRepositoryProtocol.swift
//  shopify-ecommerce-ios
//
//  Created by Mahmoud Raafat Mustafa on 07/07/2026.
//

import Foundation
import UIKit

protocol ChatRepositoryProtocol {
    func sendMessage(_ message: String) async throws -> AIResponse
    func sendMessageWithImage(_ image: UIImage, message: String?) async throws -> AIResponse
    func compareProducts(_ product1: Product, _ product2: Product) async throws -> AIResponse
    func getOverallSuggestions() async throws -> AIResponse
}
