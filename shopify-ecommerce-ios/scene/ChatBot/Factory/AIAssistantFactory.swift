//
//  AIAssistantFactory.swift
//  shopify-ecommerce-ios
//
//  Created by Mahmoud Raafat Mustafa on 07/07/2026.
//

import Foundation

@MainActor
final class AIAssistantFactory {
    static func makeAIAssistantViewModel(isGuestMode: Bool = false) -> AIAssistantViewModel {
        
        let homeRemoteDataSource = HomeRemoteDataSource()
        let homeRepository = HomeRepoImpl(service: homeRemoteDataSource)
        let productContextProvider = ProductContextProvider(homeRepo: homeRepository)
        let chatRemoteDataSource = ChatRemoteDataSource(productContextProvider: productContextProvider)
        let chatRepository = ChatRepositoryImpl(remoteDataSource: chatRemoteDataSource)

        let sendMessageUseCase = SendMessageUseCase(repository: chatRepository)
        let sendImageMessageUseCase = SendImageMessageUseCase(repository: chatRepository)
        let compareProductsUseCase = CompareProductsUseCase(repository: chatRepository)
        let getSuggestionsUseCase = GetSuggestionsUseCase(repository: chatRepository)

        let viewModel = AIAssistantViewModel(
            sendMessageUseCase: sendMessageUseCase,
            sendImageMessageUseCase: sendImageMessageUseCase,
            compareProductsUseCase: compareProductsUseCase,
            getSuggestionsUseCase: getSuggestionsUseCase
        )
        viewModel.isGuestMode = isGuestMode

        return viewModel
    }
}
