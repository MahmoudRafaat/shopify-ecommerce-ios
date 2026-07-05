//
//  ProductPriceView.swift
//  shopify-ecommerce-ios
//
//  Created by Yomna on 03/07/2026.
//

// ProductPriceView.swift

import SwiftUI

struct ProductPriceView: View {

    let oldPrice: String
    let currentPrice: String
    let discount: String

    var body: some View {

        HStack(spacing: 12) {

            Text(oldPrice)
                .strikethrough()
                .foregroundStyle(.secondary)

            Text(currentPrice)
                .font(.title2)
                .fontWeight(.bold)

            Text(discount)
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundStyle(.red)

            Spacer()
        }
    }
}
//#Preview {
//    ProductPriceView()
//}
