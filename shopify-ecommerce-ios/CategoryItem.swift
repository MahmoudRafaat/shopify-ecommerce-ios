//
//  CategoryItem.swift
//  shopify-ecommerce-ios
//
//  Created by Yomna on 30/06/2026.
//

import SwiftUI

struct CategoryItem: View {
    let category: Category

       var body: some View {
           VStack(spacing: 8) {

               Image(category.imageName)
                   .resizable()
                   .scaledToFit()
                   .frame(width: 70, height: 70)

               Text(category.title)
                   .font(.subheadline)
//                   .fontWeight(.medium)
                   .foregroundStyle(.black)
           }
           .frame(width: 80)
       }
}

#Preview {
    CategoryItem(category: Category(title: "Beauty", imageName: "category-image"))
}
