//
//  SearchRootView.swift
//  shopify-ecommerce-ios
//
//  Created by albaraa alsayed on 21/01/1448 AH.
//

import SwiftUI

struct SearchRootView: View {
    @State private var coordinator = SearchCoordinator()
    
    var body: some View {
        @Bindable var bindableCoordinator = coordinator
        
        NavigationStack(path: $bindableCoordinator.navigationPath) {
            SearchView()
                .navigationDestination(for: SearchCoordinator.Destination.self) { destination in
                switch destination {
                case.productDetail(productId: let productId):
                    let remoteDataSource = ProductDetailsRemoteDataSourceImpl()
                    let repository = ProductDetailsRepositoryImpl(remoteDataSource: remoteDataSource)
                    let useCase = GetProductDetailsUseCaseImpl(repository: repository)
                    let viewModel = ProductDetailsViewModel(productId: productId, getProductDetailsUseCase: useCase)
                    ProductDetailsScreen(viewModel: viewModel)
                }
            }
        }
        .environment(coordinator)
    }
}
