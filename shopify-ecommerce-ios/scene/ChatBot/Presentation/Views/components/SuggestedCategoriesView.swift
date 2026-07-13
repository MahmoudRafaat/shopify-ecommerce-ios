//
//  SuggestedCategoriesView.swift
//  shopify-ecommerce-ios
//
//  Created by Mahmoud Raafat Mustafa on 07/07/2026.
//

import SwiftUI

struct SuggestedCategoriesView: View {
    let categories: [Category]
    @Environment(HomeCoordinator.self) var coordinator
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("📂 Suggested Categories")
                .font(.headline)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(categories) { category in
                        Button {
                            coordinator.goToCategoriesScreen(id: category.id)
                        } label: {
                            HStack {
                                CachedImageLoader(
                                    urlString: category.imageName,
                                    width: 30,
                                    height: 30
                                )
                                .clipShape(Circle())
                                
                                Text(category.title)
                                    .font(.caption)
                            }
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .background(Color(.systemGray6))
                            .clipShape(Capsule())
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
        }
        .padding()
        .background(AppColor.backgroundPrimary)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(radius: 2)
    }
}
