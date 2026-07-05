//
//  ProductTagsView.swift
//  shopify-ecommerce-ios
//
//  Created by Yomna on 03/07/2026.
//

// ProductTagsView.swift

import SwiftUI

struct ProductTagsView: View {

    let tags: [ProductTag]

    var body: some View {

        ScrollView(
            .horizontal,
            showsIndicators: false
        ) {

            HStack(spacing: 12) {

                ForEach(tags) { tag in

                    ProductTagChip(
                        tag: tag
                    )
                }
            }
        }
    }
}
//
//#Preview {
//    ProductTagsView()
//}
