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
    @AppStorage(AppConstants.isGuestMode) private var isGuestMode = false
    @State private var showLoginAlert = false

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
                                         if isGuestMode { showLoginAlert = true }
                                         else { selectedTab = .cart }
                                     } label: {
                                         Image(systemName: "cart")
                                             .font(.system(size: 18, weight: .medium))
                                             .foregroundStyle(AppColor.textPrimary)
                                             .frame(width: 40, height: 40)
                                             .background(Color(.systemGray6))
                                             .clipShape(Circle())
                                     }
                                 }
                             }

                    case .categoriesScreen(let categoryId):
                        CollectionScreenView(id: categoryId)
                    case .profileDetails:
                        ProfileDetailsView(viewModel: ProfileViewModel())
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
                                .foregroundStyle(AppColor.textPrimary)
                                .frame(width: 32, height: 32)
                                .background(Color(.systemGray6))
                                .clipShape(Circle())
                        }
                    }
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            if isGuestMode { showLoginAlert = true }
                            else {
                                coordinator.dismissAIAssistant()
                                selectedTab = .cart
                            }
                        } label: {
                            Image(systemName: "cart")
                                .font(.system(size: 18, weight: .medium))
                                .foregroundStyle(AppColor.textPrimary)
                                .frame(width: 40, height: 40)
                                .background(Color(.systemGray6))
                                .clipShape(Circle())
                        }
                    }
                }
            }
        }
        .alert("Login Required", isPresented: $showLoginAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Login Now") {
                isGuestMode = false
            }
        } message: {
            Text("Please login to access this feature.")
        }
        .alert("No Internet Connection", isPresented: Binding(
            get: { coordinator.showNetworkAlert },
            set: { coordinator.showNetworkAlert = $0 }
        )) {
            Button("Settings") {
                if let url = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(url)
                }
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("Please check your internet connection before continuing.")
        }
    }
}

#Preview {
    HomeRootView(
        selectedTab: .constant(.home),
        viewModel: HomeFactory.makeHomeViewModel()
    )
}
