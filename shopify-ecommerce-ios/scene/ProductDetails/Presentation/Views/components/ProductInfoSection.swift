//
//  ProductInfoSection.swift
//  shopify-ecommerce-ios
//
//  Created by Yomna on 03/07/2026.
//

// ProductInfoSection.swift

import SwiftUI

struct ProductInfoSection: View {

    let state: ProductInfoSectionState

    @State private var showFullDescription = false

    var body: some View {

        VStack(
            alignment: .leading,
            spacing: 16
        ) {

            titleSection

            ProductRatingView(
                rating: state.rating,
                reviews: state.reviewCount
            )

            ProductPriceView(
                oldPrice: state.oldPrice,
                currentPrice: state.currentPrice,
                discount: state.discountText
            )

            descriptionSection

            ProductTagsView(
                tags: state.tags
            )
        }
    }
}
private extension ProductInfoSection {

    var titleSection: some View {

        VStack(
            alignment: .leading,
            spacing: 4
        ) {

            Text(state.title)
                .font(.title2)
                .fontWeight(.bold)

            Text(state.subtitle)
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
    }
}
private extension ProductInfoSection {

    var descriptionSection: some View {

        VStack(
            alignment: .leading,
            spacing: 8
        ) {

            Text("Description")
                .font(.headline)

            Group {

                if showFullDescription {

                    Text(state.description)

                } else {

                    Text(state.description)
                        .lineLimit(3)
                }
            }
            .font(.subheadline)
            .foregroundStyle(.secondary)

            Button {

                withAnimation {

                    showFullDescription.toggle()
                }

            } label: {

                Text(
                    showFullDescription
                    ? "Less"
                    : "More..."
                )
                .fontWeight(.semibold)
                .foregroundStyle(Color("appPink"))
            }
        }
    }
}

//#Preview {
//    ProductInfoSection()
//}
