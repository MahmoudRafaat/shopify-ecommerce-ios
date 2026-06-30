//
//  ProductsScrollView.swift
//  shopify-ecommerce-ios
//
//  Created by albaraa alsayed on 13/01/1448 AH.
//

import SwiftUI

struct ProductsScrollView: View {
    let products: [Product]
    @State private var isAnimating = false
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 16) {
                ForEach(Array(products.enumerated()), id: \.element.id) { index, product in
                    ProductCardView(product: product)
                        .opacity(isAnimating ? 1 : 0)
                        .scaleEffect(isAnimating ? 1 : 0.8)
                        .animation(
                            .spring(response: 0.5, dampingFraction: 0.6, blendDuration: 0)
                            .delay(Double(index) * 0.1),
                            value: isAnimating
                        )
                        .scrollTransition(axis: .horizontal) { content, phase in
                            content
                                .scaleEffect(phase.isIdentity ? 1.0 : 0.85)
                                .opacity(phase.isIdentity ? 1.0 : 0.6)
                        }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 20)
        }
        .onAppear {
            isAnimating = true
        }
    }
}

#Preview {
    
    let viewModel = HomeViewModel()
    ProductsScrollView(products: viewModel.products)
}
