//
//  AIAssistantFactory.swift
//  shopify-ecommerce-ios
//
//  Created by Mahmoud Raafat Mustafa on 07/07/2026.
//


//
//  AIAssistantFactory.swift
//  shopify-ecommerce-ios
//

import Foundation

@MainActor
final class AIAssistantFactory {
    static func makeAIAssistantViewModel(isGuestMode: Bool = false) -> AIAssistantViewModel {
        let remoteService = HomeRemoteDataSource()
        let repository = HomeRepoImpl(service: remoteService)
        let productContextProvider = ProductContextProvider(homeRepo: repository)
        let geminiService = GeminiService(productContextProvider: productContextProvider)
        
        let viewModel = AIAssistantViewModel(
            geminiService: geminiService,
            productContextProvider: productContextProvider
        )
        viewModel.isGuestMode = isGuestMode
        
        return viewModel
    }
}