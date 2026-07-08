//
//  FavoriteView.swift
//  shopify-ecommerce-ios
//
//  Created by Ehab Salah on 07/07/2026.
//

import SwiftUI

struct FavoriteView: View {
    @State private var viewModel = FavoritesViewModel()
    @State private var navigateToProductDetails = false
    @State private var selectedProductId: Int?
    
    var body: some View {
        VStack(spacing: 0) {
            FavoriteHeaderView()
            
            if viewModel.favorites.isEmpty {
                Spacer()
                VStack(spacing: 16) {
                    Image(systemName: "heart.slash")
                        .font(.system(size: 48))
                        .foregroundColor(.gray)
                    Text("No Favorites Yet")
                        .font(.headline)
                        .foregroundColor(.gray)
                }
                Spacer()
            } else {
                FavoriteGridView(
                    favorites: viewModel.favorites,
                    onRemoveFavorite: { id in
                        viewModel.removeFavorite(id: id)
                    },
                    onProductTap: { product in
                        selectedProductId = product.id
                        navigateToProductDetails = true
                    }
                )
            }
        }
        .showLoading(if: viewModel.isLoading)
        .onAppear {
            viewModel.fetchFavorites()
        }
        .navigationDestination(isPresented: $navigateToProductDetails) {
            if let id = selectedProductId {
                ProductDetailsScreen(id: id)
            }
        }
    }
}

#Preview {
    FavoriteView()
}
