//
//  SuggestedProductsView.swift
//  shopify-ecommerce-ios
//
//  Created by Mahmoud Raafat Mustafa on 07/07/2026.
//

import SwiftUI

struct SuggestedProductsView: View {
    let products: [Product]
    @Environment(HomeCoordinator.self) var coordinator
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("🛍️ Suggested Products")
                .font(.headline)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(products) { product in
                        Button {
                            coordinator.goToProductDetail(id: product.id)
                        } label: {
                            VStack(alignment: .leading, spacing: 4) {
                                CachedImageLoader(
                                    urlString: product.image,
                                    width: 80,
                                    height: 80
                                )
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                                
                                Text(product.name)
                                    .font(.caption)
                                    .lineLimit(1)
                                
                                Text("$\(product.price, specifier: "%.2f")")
                                    .font(.caption.bold())
                            }
                            .frame(width: 100)
                            .padding(8)
                            .background(AppColor.backgroundPrimary)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .shadow(radius: 2)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
        }
        .padding()
        .background(AppColor.backgroundPrimary)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(radius: 2)
    }
}
