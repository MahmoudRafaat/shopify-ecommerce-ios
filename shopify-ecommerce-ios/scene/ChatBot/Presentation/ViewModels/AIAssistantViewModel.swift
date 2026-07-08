//
//  AIAssistantViewModel.swift
//  shopify-ecommerce-ios
//
//  Created by Mahmoud Raafat Mustafa on 07/07/2026.
//

import Foundation
import SwiftUI
import Observation
import PhotosUI

@Observable
final class AIAssistantViewModel {
    private let sendMessageUseCase: SendMessageUseCaseProtocol
    private let sendImageMessageUseCase: SendImageMessageUseCaseProtocol
    private let compareProductsUseCase: CompareProductsUseCaseProtocol
    private let getSuggestionsUseCase: GetSuggestionsUseCaseProtocol

    var messages: [Message] = []
    var isLoading = false
    var isTyping = false
    var errorMessage: String?
    var isGuestMode = false

    var suggestedProducts: [Product] = []
    var suggestedCategories: [Category] = []

    var isRecording = false
    var voiceInputText = ""

    var selectedImage: UIImage?
    var selectedPhotoItem: PhotosPickerItem? {
        didSet {
            Task {
                await loadSelectedPhoto()
            }
        }
    }
    var isImagePickerPresented = false
    
    @MainActor
    private func loadSelectedPhoto() async {
        guard let item = selectedPhotoItem else { return }
        do {
            if let data = try await item.loadTransferable(type: Data.self),
               let image = UIImage(data: data) {
                self.selectedImage = image
            }
        } catch {
            self.errorMessage = "Failed to load image."
        }
    }

    init(
        sendMessageUseCase: SendMessageUseCaseProtocol,
        sendImageMessageUseCase: SendImageMessageUseCaseProtocol,
        compareProductsUseCase: CompareProductsUseCaseProtocol,
        getSuggestionsUseCase: GetSuggestionsUseCaseProtocol
    ) {
        self.sendMessageUseCase = sendMessageUseCase
        self.sendImageMessageUseCase = sendImageMessageUseCase
        self.compareProductsUseCase = compareProductsUseCase
        self.getSuggestionsUseCase = getSuggestionsUseCase
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
                let response = try await sendMessageUseCase.execute(message: text)

                await MainActor.run {
                    self.isLoading = false
                    self.suggestedProducts = response.suggestedProducts
                    self.suggestedCategories = response.suggestedCategories
                }

                await revealMessage(response.text, isUser: false)

            } catch {
                await MainActor.run {
                    self.isLoading = false
                    self.handle(error)
                }
            }
        }
    }

    @MainActor
    private func revealMessage(_ fullText: String, isUser: Bool) async {
        let message = Message(content: "", isUser: isUser, timestamp: Date())
        messages.append(message)
        guard let index = messages.firstIndex(where: { $0.id == message.id }) else { return }

        
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
            try? await Task.sleep(nanoseconds: 40_000_000) 
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
                let response = try await sendImageMessageUseCase.execute(image: image, message: text)

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
                let response = try await compareProductsUseCase.execute(product1: product1, product2: product2)

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
                let response = try await getSuggestionsUseCase.execute()

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
