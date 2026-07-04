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
        ScrollView {
            VStack(spacing: 24) {
                
                HeaderView(onSearchTap: {
                    selectedTab = .search
                })
                
                Text("All Featured")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 16)
                
                if let error = viewModel.errorMessage {
                    VStack(spacing: 12) {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .font(.system(size: 40))
                            .foregroundColor(.red)
                        
                        Text("Oops! Something went wrong.")
                            .font(.headline)
                        
                        Text(error)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                        
                        Button(action: {
                            Task {
                                await viewModel.fetchData()
                            }
                        }) {
                            Text("Try Again")
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .padding(.horizontal, 24)
                                .padding(.vertical, 12)
                                .background(Color.blue)
                                .cornerRadius(8)
                        }
                        .padding(.top, 8)
                    }
                    .padding(.top, 32)
                    
                } else {
                    if viewModel.isCategoriesLoading {
                        ProgressView()
                            .padding(.top, 16)
                    } else {
                        CategoriesSectionView(categories: viewModel.categories)
                            .padding(.top, 16)
                    }
                    
                    CollectionOfAds()
                    
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
                                    
                                    ProductsScrollView(products: section.products,onProductTap: { productID in
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
                    
                    Spacer()
                }
            }
        }
        .task {
            await viewModel.fetchData()
        }
    }
}

#Preview {
    HomeRootView(selectedTab: .constant(.home))
}

