//
//  ProductsScrollView.swift
//  shopify-ecommerce-ios
//
//  Created by albaraa alsayed on 13/01/1448 AH.
//

import SwiftUI

struct ProductsScrollView: View {
    let products: [Product] = [
        Product(
            image: "woman",
            name: "Women Printed Kurta",
            description: "Neque porro quisquam est qui dolorem ipsum quia",
            price: 1500.0,
            discount: 40,
            stars: 4.4,
            reviewers: 3455
        ),
        Product(
            image: "woman",
            name: "Elegant Summer Dress",
            description: "Comfortable and stylish outfit for everyday wear",
            price: 2200.0,
            discount: 25,
            stars: 4.7,
            reviewers: 2890
        ),
        Product(
            image: "woman",
            name: "Classic Women Outfit",
            description: "Premium fabric with modern design collection",
            price: 1800.0,
            discount: 35,
            stars: 4.2,
            reviewers: 4120
        ),
        Product(
            image: "woman",
            name: "Classic Women Outfit",
            description: "Premium fabric with modern design collection",
            price: 1800.0,
            discount: 35,
            stars: 4.2,
            reviewers: 4120
        ),
        Product(
            image: "woman",
            name: "Classic Women Outfit",
            description: "Premium fabric with modern design collection",
            price: 1800.0,
            discount: 35,
            stars: 4.2,
            reviewers: 4120
        )
    ]
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
    ProductsScrollView()
}
