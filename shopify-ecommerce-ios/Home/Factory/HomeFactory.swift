//
//  HomeFactory.swift
//  shopify-ecommerce-ios
//
//  Created by albaraa alsayed on 15/01/1448 AH.
//

import SwiftUI

@MainActor
struct HomeFactory {
    
    static func makeHomeView(diContainer: AppDIContainer) -> some View {
        
        // 1. Coordinator
        let coordinator = HomeCoordinator()
        
        // 2. Data Source (Injecting the API credentials from the DI Container)
        let remoteService = HomeRemoteDataSource(baseURL: diContainer.shopifyBaseURL)
        
        // 3. Repository
        let repository = HomeRepoImpl(service: remoteService)
        
        // 4. Use Cases
        let getProductsUseCase = GetProductsUseCase(repository: repository)
        let getCategoriesUseCase = GetCategoriesUseCase(repository: repository)
        
        // 5. ViewModel (Needs to be updated to accept UseCases)
        let viewModel = HomeViewModel(
            getProductsUseCase: getProductsUseCase,
            getCategoriesUseCase: getCategoriesUseCase,
            coordinator: coordinator
        )
        
        // 6. View
        return HomeScreenView(viewModel: viewModel)
            .environmentObject(coordinator)
    }
}
