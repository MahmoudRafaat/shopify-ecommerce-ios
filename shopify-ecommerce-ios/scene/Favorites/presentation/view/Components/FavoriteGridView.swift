//
//  FavoriteGridView.swift
//  shopify-ecommerce-ios
//
//  Created by Ehab Salah on 07/07/2026.
//

import SwiftUI

struct FavoriteGridView: View {
    let favorites: [FavoriteProduct]
    let onRemoveFavorite: (Int) -> Void
    let onProductTap: (FavoriteProduct) -> Void
    
    private let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(favorites, id: \.id) { product in
                    ProductCardView(
                        uiState: ProductUIState(favoriteProduct: product),
                        onFavoriteToggle: {
                            onRemoveFavorite(product.id)
                        },
                        onTap: {
                            onProductTap(product)
                        }
                    )
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 16)
        }
    }
}

#Preview {
    FavoriteGridView(
        favorites: [
            FavoriteProduct(
                id: 1,
                image: "watch",
                name: "Product Name",
                productDescription: "Description here",
                price: 15.0,
                isAvailable: true,
                productType: "Type",
                vendor: "Vendor"
            )
        ],
        onRemoveFavorite: { _ in },
        onProductTap: { _ in }
    )
}
