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
            
            ScrollView(.vertical, showsIndicators: false) {
                LazyVGrid(columns: columns) {
                    ForEach(0..<viewModel.products.count, id: \.self) { index in
                        let product = viewModel.products[index]
                        
                        ProductCardView(uiState: ProductUIState(product: product)) {
                            coordinator.navigationPath.append(HomeCoordinator.Destination.productDetail(productId: product.id))
                        }
                        .onAppear {
                            if index == viewModel.products.count - 1 {
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
        .task {
            await viewModel.fetchProducts()
        }
    }
}

#Preview {
    CollectionScreenView(id: 312382259336)
        .environment(HomeCoordinator()) 
}
