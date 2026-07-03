//
//  CategoryItem.swift
//  shopify-ecommerce-ios
//
//  Created by Yomna on 30/06/2026.
//

import SwiftUI
import Kingfisher

struct CategoryItem: View {
    let category: Category
    
    var body: some View {
        VStack(spacing: 8) {
            
            CachedImageLoader(
                urlString: category.imageName,
                width: 70,
                height: 70
            )
            .clipShape(Circle())
            
            Text(category.title)
                .font(.subheadline)
                .foregroundStyle(.black)
        }
        .frame(width: 80)
    }
}

#Preview {
    CategoryItem(category: Category(
        id: 1,
        title: "Beauty", imageName: "category-image"))
}
