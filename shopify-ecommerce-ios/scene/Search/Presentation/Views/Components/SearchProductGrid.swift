//
//  SearchProductGrid.swift
//  shopify-ecommerce-ios
//
//  Created by albaraa alsayed on 20/01/1448 AH.
//

import SwiftUI

struct SearchProductGrid: View {
    @Environment(SearchCoordinator.self) private var coordinator
    
    let products: [SearchProduct]
    let canLoadMore: Bool
    let onReachedBottom: () -> Void
    
    private let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    @State private var isAnimating = false
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(Array(products.enumerated()), id: \.element.id) { index, product in
                    ProductCardView(uiState: ProductUIState(searchProduct: product), onTap: {
                        coordinator.goToProductDetail(id: product.id)
                    })
                        .opacity(isAnimating ? 1 : 0)
                        .scaleEffect(isAnimating ? 1 : 0.8)
                        .animation(
                            .spring(response: 0.5, dampingFraction: 0.6, blendDuration: 0)
                            .delay(Double(index % 20) * 0.05),
                            value: isAnimating
                        )
                        .onAppear {
                            if index == products.count - 1 {
                                onReachedBottom()
                            }
                        }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            
            if canLoadMore {
                HStack {
                    Spacer()
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .appBlue))
                        .padding(.vertical, 20)
                    Spacer()
                }
            }
        }
        .onAppear {
            isAnimating = true
        }
    }
}
