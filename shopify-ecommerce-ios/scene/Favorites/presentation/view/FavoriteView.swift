//
//  FavoriteView.swift
//  shopify-ecommerce-ios
//
//  Created by Ehab Salah on 07/07/2026.
//

import SwiftUI

struct FavoriteView: View {
    @State private var viewModel = FavoritesViewModel()
    
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
                        // Handle product tap (e.g., navigate to details)
                    }
                )
            }
        }
        .showLoading(if: viewModel.isLoading)
        .onAppear {
            viewModel.fetchFavorites()
        }
    }
}

#Preview {
    FavoriteView()
}
