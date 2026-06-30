//
//  HomeScreenView.swift
//  shopify-ecommerce-ios
//
//  Created by albaraa alsayed on 15/01/1448 AH.
//

import SwiftUI

struct HomeScreenView: View {
    let viewModel: HomeViewModel
    
    var body: some View {
        VStack(spacing: 32){
            HomeHeaderView(categories: viewModel.categories)
            ScrollView {
                CollectionOfAds()
                DealCard(dealName: "Deal of the Day", dealDescription: "22h 55m 20s remaining ", isToday: true)
                ProductsScrollView(products: viewModel.products)
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
