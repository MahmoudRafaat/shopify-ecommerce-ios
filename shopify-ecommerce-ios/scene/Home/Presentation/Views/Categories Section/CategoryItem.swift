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
    let action : () -> Void
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
        .onTapGesture {
            action()
        }
    }
}

#Preview {
    CategoryItem(category: Category(
        id: 1,
        title: "Beauty", imageName: "category-image")
    ) {
        
    }
}
