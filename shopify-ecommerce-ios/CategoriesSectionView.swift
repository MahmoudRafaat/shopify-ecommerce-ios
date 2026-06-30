//
//  CategoriesSectionView.swift
//  shopify-ecommerce-ios
//
//  Created by Yomna on 30/06/2026.
//

import SwiftUI

struct CategoriesSectionView: View {
    let categories: [Category]

        var body: some View {
            ScrollView(.horizontal, showsIndicators: false) {

                HStack(spacing: 16) {

                    ForEach(categories) { category in
                        CategoryItem(category: category)
                    }
                }
                .padding(.horizontal, 16)
            }  .background(.white)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .shadow(
                    color: .black.opacity(0.05),
                    radius: 8,
                    x: 0,
                    y: 2
                ).padding(.leading,16)
        }
}


