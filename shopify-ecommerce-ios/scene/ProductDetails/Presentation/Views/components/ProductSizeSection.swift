//
//  ProductSizeSection.swift
//  shopify-ecommerce-ios
//
//  Created by Yomna on 03/07/2026.
//

import SwiftUI

struct ProductSizeSection: View {

    let state: ProductSizeSectionState
    let onSizeSelected: (String) -> Void

    var body: some View {

        VStack(alignment: .leading, spacing: 16) {

            Text("Size: \(state.selectedSize)")
                .font(.headline)
                .fontWeight(.semibold)

            ScrollView(.horizontal, showsIndicators: false) {

                HStack(spacing: 12) {

                    ForEach(state.availableSizes, id: \.self) { size in

                        SizeChip(
                            title: size,
                            isSelected: size == state.selectedSize
                        ) {
                            onSizeSelected(size)
                        }
                    }
                }
            }
        }
    }
}

//#Preview {
//    ProductSizeSection()
//}
