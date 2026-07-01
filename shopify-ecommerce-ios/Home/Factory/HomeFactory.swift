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
        
        // 2. Data Source
        let remoteService = HomeRemoteDataSource(baseURL: diContainer.shopifyBaseURL)
        
        // 3. Repository
        let repository = HomeRepoImpl(service: remoteService)
        
        // 4. Use Cases
        let getProductsUseCase = GetProductsUseCase(repository: repository)
        let getCategoriesUseCase = GetCategoriesUseCase(repository: repository)
        
        // 5. ViewModel
        let viewModel = HomeViewModel(
            getProductsUseCase: getProductsUseCase,
            getCategoriesUseCase: getCategoriesUseCase,
            coordinator: coordinator
        )
        
        // 6. View & Navigation Setup
        // We bind the NavigationStack directly to the coordinator's path here
        return NavigationStack(path: Binding(
            get: { coordinator.navigationPath },
            set: { coordinator.navigationPath = $0 }
        )) {
            HomeScreenView(viewModel: viewModel)
                .environmentObject(coordinator)
                .navigationDestination(for: HomeCoordinator.Destination.self) { destination in
                    switch destination {
                    case .productDetail(let productId):
                        Text("Product Detail View for ID: \(productId)")
                    case .categoriesScreen(let categoryId):
                        Text("Categories View for ID: \(categoryId)")
                    case .searchScreen:
                        SearchView()
                    }
                }
        }
    }
}
