//
//  HomeScreenView.swift
//  shopify-ecommerce-ios
//
//  Created by albaraa alsayed on 15/01/1448 AH.
//

import SwiftUI

struct HomeScreenView: View {
    var viewModel: HomeViewModel

    @Binding var selectedTab: Tab

    @Environment(HomeCoordinator.self) var coordinator
    @AppStorage(AppConstants.isGuestMode) private var isGuestMode = false
    @State private var showLoginAlert = false

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            VStack(spacing: 0) {
                HeaderView(
                    searchText: .constant(""),
                    onSearchTap: {
                        selectedTab = .search
                    },
                    onMenuTap: {
                        if isGuestMode {
                            showLoginAlert = true
                        } else {
                            coordinator.goToProfile()
                        }
                    }
                )
                .padding(.bottom, 8)
                
                ScrollView {
                    VStack(spacing: 24) {
                        if let error = viewModel.uiState.error {
                        CustomContentUnavailableView(error: error, onRetry: {
                            Task {
                                await viewModel.fetchData()
                            }
                        })
                    } else {
                        VStack(spacing: 8) {
                            Text("All Featured")
                                .font(.title2)
                                .fontWeight(.semibold)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.horizontal, 16)

                            if viewModel.uiState.isCategoriesLoading {
                                ProgressView()
                            } else {
                                CategoriesSectionView(categories: viewModel.uiState.categories)
                            }
                        }

                        CollectionOfAds()

                        VStack(spacing: 8) {
                            Text("Top Brands")
                                .font(.title2)
                                .fontWeight(.semibold)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.horizontal, 16)

                            if viewModel.uiState.isBrandsLoading {
                                ProgressView()
                            } else {
                                CategoriesSectionView(categories: viewModel.uiState.brands)
                            }
                        }

                        DealCard(
                            dealName: "Deal of the Day",
                            dealDescription: "22h 55m 20s remaining ",
                            isToday: true
                        )

                        if viewModel.uiState.isProductsLoading {
                            ProgressView()
                                .padding(.top, 32)
                        } else {
                            ForEach(viewModel.uiState.categorySections, id: \.title) { section in
                                if !section.products.isEmpty {
                                    VStack(spacing: 0) {
                                        Text("\(section.title) Products")
                                            .font(.body.bold())
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            .padding(.leading, 16)

                                        ProductsScrollView(products: section.products, onProductTap: { productID in
                                            coordinator.goToProductDetail(id: productID)
                                        })
                                    }
                                } else {
                                    EmptyView()
                                }
                            }
                        }

                        DealCard(
                            dealName: "Trending Products",
                            dealDescription: "Last Date 29/02/22",
                            isToday: false
                        )
                    }
                }
                .padding(.bottom, 80) 
            }
            }


            AIFloatingActionButton {
                coordinator.goToAIAssistant()
            }
            .padding(.trailing, 20)
            .padding(.bottom, 35)
        }
        .refreshable {
            await viewModel.refreshData()
        }
        .tint(.appBlue)
        .task {
            await viewModel.fetchData()
        }
        .alert("Login Required", isPresented: $showLoginAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Login Now") {
                isGuestMode = false
            }
        } message: {
            Text("Please login to access this feature.")
        }
    }
}

#Preview {
    HomeRootView(
        selectedTab: .constant(.home),
        viewModel: HomeFactory.makeHomeViewModel()
    )
}
