//
//  CollectionScreenView.swift
//  shopify-ecommerce-ios
//
//  Created by albaraa alsayed on 20/01/1448 AH.
//

import SwiftUI

struct CollectionScreenView: View {
    
    @Environment(HomeCoordinator.self) private var coordinator
    
    let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    @State var viewModel: CollectionViewModel
    
    init(id: Int) {
        viewModel = CollectionFactory.makeCollectionViewModel()
        viewModel.collcetionId = id
    }
    
    var body: some View {
        VStack(spacing: 0) {
            HeaderView(searchText: Bindable(viewModel).searchText)
            
            if viewModel.uiState.isLoading {
                Spacer()
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .appBlue))
                    .scaleEffect(1.3)
                Spacer()
            } else if let error = viewModel.uiState.error {
                CustomContentUnavailableView(error: error, onRetry: {
                    Task { await viewModel.fetchProducts() }
                })
            } else if viewModel.uiState.products.isEmpty {
                Spacer()
                ContentUnavailableView {
                    Label("No products found", systemImage: "tray")
                } description: {
                    Text("Try adjusting your search.")
                }
                Spacer()
            } else {
                ScrollView(.vertical, showsIndicators: false) {
                    LazyVGrid(columns: columns) {
                        ForEach(0..<viewModel.uiState.products.count, id: \.self) { index in
                            let product = viewModel.uiState.products[index]
                            
                            ProductCardView(uiState: ProductUIState(product: product)) {
                                coordinator.navigationPath.append(HomeCoordinator.Destination.productDetail(productId: product.id))
                            }
                            .onAppear {
                                if index == viewModel.uiState.products.count - 1 {
                                    viewModel.loadMoreIfNeeded()
                                }
                            }
                        }
                        .padding(.bottom, 16)
                    }
                    .padding(16)
                    
                    if viewModel.canLoadMore {
                        HStack {
                            Spacer()
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .appBlue))
                                .padding(.vertical, 20)
                            Spacer()
                        }
                    }
                }
            }
        }
        .task {
            await viewModel.fetchProducts()
        }
    }
}

#Preview {
    CollectionScreenView(id: 312382259336)
        .environment(HomeCoordinator()) 
}
