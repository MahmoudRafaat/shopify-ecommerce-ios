//
//  AIConfig.swift
//  shopify-ecommerce-ios
//
//  Created by Mahmoud Raafat Mustafa on 07/07/2026.
//

import Foundation

struct AIConfig {
    static var geminiAPIKey: String {
        SecretConstants.geminiApiKey
    }
    static let guestModeRestricted = true
    static let modelName = "gemini-2.5-flash-lite"
    static let maxTokens = 2048
    static let temperature: Float = 0.7
}

enum AIError: Error {
    case apiKeyMissing
    case networkError
    case invalidResponse
    case guestModeRestricted
    case imageProcessingFailed
    case modelNotFound
    case rateLimitExceeded(retryAfterSeconds: Int?)

    var localizedDescription: String {
        switch self {
        case .apiKeyMissing:
            return "API key is missing. Please configure the app."
        case .networkError:
            return "Network connection error. Please try again."
        case .invalidResponse:
            return "Invalid response from AI assistant."
        case .guestModeRestricted:
            return "AI Shopping Assistant is not available in guest mode. Please sign in."
        case .imageProcessingFailed:
            return "Failed to process the image. Please try again."
        case .modelNotFound:
            return "AI model not available. Please try again later."
        case .rateLimitExceeded(let seconds):
            if let seconds {
                return "I'm getting a lot of requests right now. Please try again in \(seconds) seconds."
            }
            return "I'm getting a lot of requests right now. Please try again shortly."
        }
    }
}
