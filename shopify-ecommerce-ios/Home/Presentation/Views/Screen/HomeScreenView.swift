//
//  HomeScreenView.swift
//  shopify-ecommerce-ios
//
//  Created by albaraa alsayed on 15/01/1448 AH.
//

import SwiftUI

struct HomeScreenView: View {
    var viewModel: HomeViewModel
    
    var body: some View {
        ScrollView {
            VStack(spacing: 32) {
                HomeHeaderView()
                CategoriesSectionView(categories: viewModel.categories).padding(.top,16)
                CollectionOfAds()
                
                DealCard(
                    dealName: "Deal of the Day",
                    dealDescription: "22h 55m 20s remaining ",
                    isToday: true
                )
                
                ForEach(viewModel.categorySections, id: \.title) { section in
                    VStack(spacing: 0) {
                        Text("\(section.title) Products")
                            .font(.body.bold())
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 16)
                        
                        ProductsScrollView(products: section.products)
                    }
                }
            }
        }
        .task {
            await viewModel.fetchData()
        }
    }
}

#Preview {
    HomeFactory.makeHomeView(diContainer: AppDIContainer())
}
