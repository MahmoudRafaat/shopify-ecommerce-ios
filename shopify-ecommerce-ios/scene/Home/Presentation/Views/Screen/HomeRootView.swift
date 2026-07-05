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
    
    @State var viewModel: HomeViewModel
    
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
                        Text("Categories View for ID: \(categoryId)")
                    case .settings:
                       SettingsView()
                        .navigationBarBackButtonHidden(false)
                    }
                }
        }
    }
}

#Preview {
    HomeRootView(
        selectedTab: .constant(.home),
        viewModel: HomeFactory.makeHomeViewModel()
    )
}
