//
//  ProductRatingView.swift
//  shopify-ecommerce-ios
//
//  Created by Yomna on 03/07/2026.
//

// ProductRatingView.swift

import SwiftUI

struct ProductRatingView: View {

    let rating: Double
    let reviews: Int

    var body: some View {

        HStack(spacing: 8) {

            Image(systemName: "star.fill")
                .foregroundStyle(.yellow)

            Text(String(format: "%.1f", rating))
                .fontWeight(.semibold)

            Text("(\(reviews) Reviews)")
                .foregroundStyle(.secondary)

            Spacer()
        }
        .font(.subheadline)
    }
}

//#Preview {
//    ProductRatingView()
//}
