//
//  SearchProductGrid.swift
//  shopify-ecommerce-ios
//
//  Created by albaraa alsayed on 20/01/1448 AH.
//

import SwiftUI

struct SearchProductGrid: View {
    let products: [SearchProduct]
    
    private let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    @State private var isAnimating = false
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(Array(products.enumerated()), id: \.element.id) { index, product in
                    ProductCardView(product: Product(id: product.id, image: product.image, name: product.name, description: product.description, vendor: product.vendor, price: product.price, isAvailabe: product.isAvailabe, productType: product.productType), onTap: {})
                        .opacity(isAnimating ? 1 : 0)
                        .scaleEffect(isAnimating ? 1 : 0.8)
                        .animation(
                            .spring(response: 0.5, dampingFraction: 0.6, blendDuration: 0)
                            .delay(Double(index) * 0.05),
                            value: isAnimating
                        )
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
        }
        .onAppear {
            isAnimating = true
        }
        .onChange(of: products.count) {
            isAnimating = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                isAnimating = true
            }
        }
    }
}
