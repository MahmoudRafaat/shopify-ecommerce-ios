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
                    if product.isAvailabe == true {
                        ProductCardView(product: product, onTap: {})
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
    ProductsScrollView(products: [
        Product(
            id: 1,
            image: "watch",
            name: "2021 Pilot's Watch",
            description: "IWC Schaffhausen 2021 Pilot's Watch \"SIHH 2019\" 44mm", vendor: "Nike",
            price: 1500.0,

            isAvailabe: true,
            productType: "T-shirt"
        ),
        Product(
            id: 2,
            image: "watch",
            name: "Elegant Summer Dress",
            description: "Comfortable and stylish outfit for everyday wear", vendor: "Adidas",
            price: 2200.0,
 
            isAvailabe: true,
            productType: "T-shirt"
        ),
        Product(
            id: 3,
            image: "watch",
            name: "Classic Women Outfit",
            description: "Premium fabric with modern design collection", vendor: "Nike",
            price: 1800.0,
            isAvailabe: false,
            productType: "T-shirt"
        )
    ])
}
