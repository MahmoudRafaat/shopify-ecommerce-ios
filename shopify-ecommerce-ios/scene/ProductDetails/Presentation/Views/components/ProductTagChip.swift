//
//  ProductTagChip.swift
//  shopify-ecommerce-ios
//
//  Created by Yomna on 03/07/2026.
//

// ProductTagChip.swift

import SwiftUI

//
//  ProductTagChip.swift
//

import SwiftUI

struct ProductTagChip: View {

    let tag: ProductTag

    var body: some View {

        HStack(spacing: 6) {

            Image(systemName: tag.icon)
                .font(.caption)

            Text(tag.title)
                .font(.caption)
                .fontWeight(.medium)
        }
        .foregroundStyle(AppColor.textSecondary)
        .padding(.horizontal, 12)
        .frame(height: 32)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(AppColor.backgroundPrimary)
                .stroke(AppColor.textSecondary.opacity(0.3))
        )
    }
}
//
//#Preview {
//    ProductTagChip()
//}
