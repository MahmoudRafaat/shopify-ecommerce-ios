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
            
            if let error = viewModel.uiState.error {
                Spacer()
                CustomContentUnavailableView(error: error, onRetry: {
                    viewModel.fetchFavorites()
                })
                Spacer()
            } else if viewModel.uiState.isLoading {
                Spacer()
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .appBlue))
                    .scaleEffect(1.3)
                Spacer()
            } else if viewModel.uiState.favorites.isEmpty {
                Spacer()
                VStack(spacing: 16) {
                    Image(systemName: "heart.slash")
                        .font(.system(size: 48))
                        .foregroundColor(AppColor.textSecondary)
                    Text("No Favorites Yet")
                        .font(.headline)
                        .foregroundColor(AppColor.textSecondary)
                }
                Spacer()
            } else {
                FavoriteGridView(
                    favorites: viewModel.uiState.favorites,
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
