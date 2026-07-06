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
            HeaderView(searchText: .constant(""))
            
            ScrollView(.vertical, showsIndicators: false) {
                LazyVGrid(columns: columns) {
                    ForEach(0..<viewModel.products.count, id: \.self) { index in
                        let product = viewModel.products[index]
                        
                        ProductCardView(uiState: ProductUIState(product: product)) {
                            coordinator.navigationPath.append(HomeCoordinator.Destination.productDetail(productId: product.id))
                        }
                    }
                    .padding(.bottom, 16)
                }
                .padding(16)
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
