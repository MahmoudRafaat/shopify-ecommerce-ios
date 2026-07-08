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
                        ProductDetailsScreen(id: productId)
                            .environment(coordinator).toolbar {
                                 ToolbarItem(placement: .topBarTrailing) {
                                     Button {
                                         // Go to cart
                                     } label: {
                                         Image(systemName: "cart")
                                             .font(.system(size: 18, weight: .medium))
                                             .foregroundStyle(.black)
                                             .frame(width: 40, height: 40)
                                             .background(Color(.systemGray6))
                                             .clipShape(Circle())
                                     }
                                 }
                             }
                    case .categoriesScreen(let categoryId):
                        CollectionScreenView(id: categoryId)
                    case .settings:
                       SettingsView()
                        .navigationBarBackButtonHidden(false)
                    }
                }
        }
        .environment(coordinator)
    }
}

#Preview {
    HomeRootView(
        selectedTab: .constant(.home),
        viewModel: HomeFactory.makeHomeViewModel()
    )
}
