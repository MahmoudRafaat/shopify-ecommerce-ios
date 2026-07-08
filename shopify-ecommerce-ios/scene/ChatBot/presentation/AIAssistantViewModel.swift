//
//  AIAssistantViewModel.swift
//  shopify-ecommerce-ios
//

import Foundation
import SwiftUI
import Observation

@Observable
final class AIAssistantViewModel {
    private let geminiService: GeminiServiceProtocol
    private let productContextProvider: ProductContextProviderProtocol

    var messages: [Message] = []
    var isLoading = false
    var isTyping = false
    var errorMessage: String?
    var isGuestMode = false

    var suggestedProducts: [Product] = []
    var suggestedCategories: [Category] = []

    // Voice Input
    var isRecording = false
    var voiceInputText = ""

    // Image Picker
    var selectedImage: UIImage?
    var isImagePickerPresented = false

    init(
        geminiService: GeminiServiceProtocol,
        productContextProvider: ProductContextProviderProtocol
    ) {
        self.geminiService = geminiService
        self.productContextProvider = productContextProvider
        addWelcomeMessage()
    }

    private func addWelcomeMessage() {
        let welcomeText = """
        👋 Welcome to Stylish AI Assistant!

        I can help you with:
        • Finding products based on your preferences
        • Comparing products
        • Answering questions about products
        • Providing recommendations

        You can also upload a product image and I'll find similar items!

        How can I help you today?
        """

        messages.append(Message(
            content: welcomeText,
            isUser: false,
            timestamp: Date()
        ))
    }

    func sendMessage(_ text: String) {
        guard !text.isEmpty else { return }

        if isGuestMode && AIConfig.guestModeRestricted {
            errorMessage = AIError.guestModeRestricted.localizedDescription
            return
        }

        let userMessage = Message(content: text, isUser: true, timestamp: Date())
        messages.append(userMessage)

        isLoading = true

        Task {
            do {
                let response = try await geminiService.sendMessage(text)

                await MainActor.run {
                    self.isLoading = false
                    self.suggestedProducts = response.suggestedProducts
                    self.suggestedCategories = response.suggestedCategories
                }

                // Reveal the reply progressively instead of all at once
                await revealMessage(response.text, isUser: false)

            } catch {
                await MainActor.run {
                    self.isLoading = false
                    self.handle(error)
                }
            }
        }
    }

    /// Appends a message and grows its content over time, simulating streaming.
    @MainActor
    private func revealMessage(_ fullText: String, isUser: Bool) async {
        let message = Message(content: "", isUser: isUser, timestamp: Date())
        messages.append(message)
        guard let index = messages.firstIndex(where: { $0.id == message.id }) else { return }

        // Reveal word by word — feels more natural than character-by-character
        // and is much cheaper than animating every single character.
        let words = fullText.split(separator: " ", omittingEmptySubsequences: false)
        var current = ""

        for word in words {
            current += (current.isEmpty ? "" : " ") + word
            messages[index] = Message(
                content: current,
                isUser: isUser,
                timestamp: message.timestamp,
                attachments: message.attachments
            )
            try? await Task.sleep(nanoseconds: 40_000_000) // ~40ms per word, tune to taste
        }
    }

    func sendMessageWithImage(_ image: UIImage, text: String?) {
        guard !isGuestMode || !AIConfig.guestModeRestricted else {
            errorMessage = AIError.guestModeRestricted.localizedDescription
            return
        }

        let imageAttachment = MessageAttachment(
            type: .image,
            data: image.jpegData(compressionQuality: 0.7)!,
            thumbnail: image.jpegData(compressionQuality: 0.3),
            fileName: "uploaded_image.jpg"
        )

        let userMessage = Message(
            content: text ?? "I'm looking for this product or something similar.",
            isUser: true,
            timestamp: Date(),
            attachments: [imageAttachment]
        )
        messages.append(userMessage)

        isLoading = true

        Task {
            do {
                let response = try await geminiService.sendMessageWithImage(image, message: text)

                await MainActor.run {
                    self.isLoading = false
                    self.suggestedProducts = response.suggestedProducts
                    self.suggestedCategories = response.suggestedCategories

                    let assistantMessage = Message(
                        content: response.text,
                        isUser: false,
                        timestamp: Date()
                    )
                    self.messages.append(assistantMessage)
                    self.selectedImage = nil
                }
            } catch {
                await MainActor.run {
                    self.isLoading = false
                    self.selectedImage = nil
                    self.handle(error)
                }
            }
        }
    }

    func compareProducts(_ product1: Product, _ product2: Product) {
        let comparisonText = """
        Please compare these two products:

        Product 1: \(product1.name)
        Product 2: \(product2.name)
        """

        let userMessage = Message(content: comparisonText, isUser: true, timestamp: Date())
        messages.append(userMessage)

        isLoading = true

        Task {
            do {
                let response = try await geminiService.compareProducts(product1, product2)

                await MainActor.run {
                    self.isLoading = false
                    self.suggestedProducts = response.suggestedProducts
                    self.suggestedCategories = response.suggestedCategories

                    let assistantMessage = Message(
                        content: response.text,
                        isUser: false,
                        timestamp: Date()
                    )
                    self.messages.append(assistantMessage)
                }
            } catch {
                await MainActor.run {
                    self.isLoading = false
                    self.handle(error)
                }
            }
        }
    }

    func getOverallSuggestions() {
        let message = "I'd like to get some overall shopping suggestions based on what's popular."

        let userMessage = Message(content: message, isUser: true, timestamp: Date())
        messages.append(userMessage)

        isLoading = true

        Task {
            do {
                let response = try await geminiService.getOverallSuggestions()

                await MainActor.run {
                    self.isLoading = false
                    self.suggestedProducts = response.suggestedProducts
                    self.suggestedCategories = response.suggestedCategories

                    let assistantMessage = Message(
                        content: response.text,
                        isUser: false,
                        timestamp: Date()
                    )
                    self.messages.append(assistantMessage)
                }
            } catch {
                await MainActor.run {
                    self.isLoading = false
                    self.handle(error)
                }
            }
        }
    }

    // MARK: - Centralized error handling

    /// Routes errors to the right presentation: rate-limit and model-not-found
    /// errors show up as a normal assistant chat bubble (feels conversational,
    /// not alarming); everything else falls back to the error banner.
    /// Must be called on the main actor.
    private func handle(_ error: Error) {
        if let aiError = error as? AIError {
            switch aiError {
            case .rateLimitExceeded, .modelNotFound:
                let assistantMessage = Message(
                    content: "⏳ \(aiError.localizedDescription)",
                    isUser: false,
                    timestamp: Date()
                )
                messages.append(assistantMessage)
            default:
                errorMessage = aiError.localizedDescription
            }
        } else {
            errorMessage = error.localizedDescription
        }
    }

    func clearConversation() {
        messages.removeAll()
        suggestedProducts.removeAll()
        suggestedCategories.removeAll()
        selectedImage = nil
        errorMessage = nil
        addWelcomeMessage()
    }
}
