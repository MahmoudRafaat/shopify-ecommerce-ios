//
//  CollectionScreenView.swift
//  shopify-ecommerce-ios
//
//  Created by albaraa alsayed on 20/01/1448 AH.
//

import SwiftUI

struct CollectionScreenView: View {
    let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    @State var viewModel : CollectionViewModel
    
    init(id: Int) {
        viewModel = CollectionFactory.makeCollectionViewModel()
        viewModel.collcetionId = id
    }
    
    var body: some View {
        
        HeaderView()
        ScrollView{
            LazyVGrid(columns: columns){
                ForEach(0..<viewModel.products.count, id: \.self) { index in
                    ProductCardView(uiState: ProductUIState(product: viewModel.products[index]))
                    {
                        
                    }
                }.padding(.bottom, 16)
            }
            .padding(16)
        }
        .task {
            await viewModel.fetchProducts()
        }
    }
}

#Preview {
    CollectionScreenView(
        id: 312382259336
    )
}
