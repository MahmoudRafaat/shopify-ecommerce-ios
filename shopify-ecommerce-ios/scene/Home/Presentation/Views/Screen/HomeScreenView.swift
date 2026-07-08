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

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            ScrollView {
                VStack(spacing: 24) {
                    HeaderView(
                        searchText: .constant(""),
                        onSearchTap: {
                            selectedTab = .search
                        },
                        onMenuTap: {
                            coordinator.goToSettings()
                        }
                    )

                    if viewModel.errorMessage != nil {
                        ContentUnavailableView {
                            Label("Oops.. Something went wrong.", systemImage: "exclamationmark.triangle.fill")
                        } description: {
                            Text("Check your internet connection and try again.")
                        } actions: {
                            Button("Try Again") {
                                Task {
                                    await viewModel.fetchData()
                                }
                            }
                            .buttonStyle(.borderedProminent)
                            .tint(.appBlue)
                            .controlSize(.regular)
                        }
                    } else {
                        VStack(spacing: 8) {
                            Text("All Featured")
                                .font(.title2)
                                .fontWeight(.semibold)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.horizontal, 16)

                            if viewModel.isCategoriesLoading {
                                ProgressView()
                            } else {
                                CategoriesSectionView(categories: viewModel.categories)
                            }
                        }

                        CollectionOfAds()

                        VStack(spacing: 8) {
                            Text("Top Brands")
                                .font(.title2)
                                .fontWeight(.semibold)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.horizontal, 16)

                            if viewModel.isBrandsLoading {
                                ProgressView()
                            } else {
                                CategoriesSectionView(categories: viewModel.brands)
                            }
                        }

                        DealCard(
                            dealName: "Deal of the Day",
                            dealDescription: "22h 55m 20s remaining ",
                            isToday: true
                        )

                        if viewModel.isProductsLoading {
                            ProgressView()
                                .padding(.top, 32)
                        } else {
                            ForEach(viewModel.categorySections, id: \.title) { section in
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
            .task {
                await viewModel.fetchData()
            }


            Button {
                coordinator.goToAIAssistant()
            } label: {
                Image(systemName: "sparkles")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(.white)
                    .frame(width: 56, height: 56)
                    .background(Color.blue)
                    .clipShape(Circle())
                    .shadow(radius: 6, y: 3)
            }
            .padding(.trailing, 20)
            .padding(.bottom, 25)
        }
    }
}

#Preview {
    HomeRootView(
        selectedTab: .constant(.home),
        viewModel: HomeFactory.makeHomeViewModel()
    )
}
