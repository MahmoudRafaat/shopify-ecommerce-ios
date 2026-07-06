//
//  ProductImageSection.swift
//  shopify-ecommerce-ios
//
//  Created by Yomna on 03/07/2026.
//

import SwiftUI

import SwiftUI

struct ProductImageSection: View {

    let state: ProductImageSectionState

    @State private var selectedIndex = 0

    var body: some View {

        VStack(spacing: 16) {

            TabView(selection: $selectedIndex) {

                ForEach(state.images.indices, id: \.self) { index in

                    AsyncImage(
                        url: URL(string: state.images[index])
                    ) { image in

                        image
                            .resizable()
                            .scaledToFill()

                    } placeholder: {

                        ProgressView()
                    }
                    .tag(index)
                    .clipShape(
                        RoundedRectangle(cornerRadius: 24)
                    )
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .frame(maxWidth: .infinity)
            .frame(height: 260)
            .clipShape(
                RoundedRectangle(cornerRadius: 24)
            )

            customPageIndicator
        }
    }
}
private extension ProductImageSection {

    var customPageIndicator: some View {

        HStack(spacing: 8) {

            ForEach(state.images.indices, id: \.self) { index in

                Circle()
                    .fill(
                        index == selectedIndex
                        ? Color("appPink") // Use your Assets color
                        : Color.gray.opacity(0.3)
                    )
                    .frame(width: 8, height: 8)
            }
        }
    }
}

#Preview {

    ProductImageSection(
        state: ProductImageSectionState(
            images: [
                "https://images.unsplash.com/photo-1542291026-7eec264c27ff",
                "https://images.unsplash.com/photo-1543508282-6319a3e2621f"
            ],
            selectedIndex: 0
        )
    )
    .padding()
}
