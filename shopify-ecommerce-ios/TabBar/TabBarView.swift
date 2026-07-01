//
//  TabBar.swift
//  shopify-ecommerce-ios
//
//  Created by albaraa alsayed on 12/01/1448 AH.
//

import SwiftUI

struct TabBarView: View {
    @State private var selectedTab: Tab = .home
    
    var body: some View {
        ZStack(alignment: .bottom) {
            TabView(selection: $selectedTab) {
                HomeFactory.makeHomeView(diContainer: .init())
                    .tag(Tab.home)
                .tag(Tab.home)
                NavigationStack {
                    Text("Wishlist Screen")
                }
                .tag(Tab.wishlist)
                NavigationStack {
                    Text("Cart Screen")
                }
                .tag(Tab.cart)
                NavigationStack {
                    Text("Search Screen")
                }
                .tag(Tab.search)
                NavigationStack{
                    SearchView()
                }
                .tag(Tab.setting)
            }
            .toolbar(.hidden, for: .tabBar)
            CustomTabBarView(selectedTab: $selectedTab)
        }
        .ignoresSafeArea(.keyboard)
    }
}

#Preview {
    TabBarView()
}
