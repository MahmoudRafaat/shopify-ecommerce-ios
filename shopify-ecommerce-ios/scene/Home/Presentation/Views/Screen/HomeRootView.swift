//
//  HomeRootView.swift
//  shopify-ecommerce-ios
//
//  Created by albaraa alsayed on 16/01/1448 AH.
//

import SwiftUI
import Observation

struct HomeRootView: View {
    
    @Binding var selectedTab: Tab
    
    @State private var coordinator = HomeCoordinator()
    @State private var viewModel: HomeViewModel
    
    init(selectedTab: Binding<Tab>) {
        self._selectedTab = selectedTab
        
        let remoteService = HomeRemoteDataSource()
        let repository = HomeRepoImpl(service: remoteService)
        let getProductsUseCase = GetProductsUseCase(repository: repository)
        let getCategoriesUseCase = GetCategoriesUseCase(repository: repository)
        
        _viewModel = State(initialValue: HomeViewModel(
            getProductsUseCase: getProductsUseCase,
            getCategoriesUseCase: getCategoriesUseCase
        ))
    }
    
    var body: some View {
        @Bindable var bindableCoordinator = coordinator
        
        NavigationStack(path: $bindableCoordinator.navigationPath) {
            HomeScreenView(viewModel: viewModel, selectedTab: $selectedTab)
                .environment(coordinator)
                .navigationDestination(for: HomeCoordinator.Destination.self) { destination in
                    switch destination {
                    case .productDetail(let productId):
                        Text("Product Detail View for ID: \(productId)")
                    case .categoriesScreen(let categoryId):
                        CollectionScreenView(id: categoryId)
                    }
                }
        }
        .environment(coordinator)
    }
}
