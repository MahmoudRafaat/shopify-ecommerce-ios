//
//  CategoriesSectionView.swift
//  shopify-ecommerce-ios
//
//  Created by Yomna on 30/06/2026.
//

import SwiftUI

struct CategoriesSectionView: View {
    @Environment(HomeCoordinator.self) private var coordinator
    
    let categories: [Category]
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 16) {
                ForEach(categories) { category in
                    CategoryItem(category: category) {
                        coordinator.goToCategoriesScreen(id: category.id)
                    }
                }
            }
            .padding( 16)
        }  .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .shadow(
                color: .black.opacity(0.05),
                radius: 8,
                x: 0,
                y: 2
            )
            .padding(.leading,16)
    }
}


#Preview {
    CategoriesSectionView(categories: [ Category(id: 1,title: "Beauty", imageName: "category-image"),
                                        Category(id: 2,title: "Fashion", imageName: "category-image"),
                                        Category(id: 3,title: "Kids", imageName: "category-image"),
                                        Category(id: 4,title: "Mens", imageName: "category-image"),
                                        Category(id: 5,title: "Womens", imageName: "category-image")])
    .environment(HomeCoordinator())
}
