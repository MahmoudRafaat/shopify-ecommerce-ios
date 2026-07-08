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
        .fullScreenCover(isPresented: $bindableCoordinator.isShowingAIAssistant) {
            NavigationStack {
                AIAssistantView(
                    viewModel: AIAssistantFactory.makeAIAssistantViewModel(
                        isGuestMode: false // Pass guest mode status from your app
                    )
                )
                .environment(coordinator)
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button {
                            coordinator.dismissAIAssistant()
                        } label: {
                            Image(systemName: "xmark")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundStyle(.black)
                                .frame(width: 32, height: 32)
                                .background(Color(.systemGray6))
                                .clipShape(Circle())
                        }
                    }
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            // Cart action
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
