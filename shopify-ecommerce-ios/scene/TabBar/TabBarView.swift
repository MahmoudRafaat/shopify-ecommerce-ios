//
//  TabBar.swift
//  shopify-ecommerce-ios
//
//  Created by albaraa alsayed on 12/01/1448 AH.
//

import SwiftUI

struct TabBarView: View {
    @Environment(NetworkMonitor.self) private var networkMonitor: NetworkMonitor
    @State private var selectedTab: Tab = .home
    
    var body: some View {
        ZStack(alignment: .bottom) {
            TabView(selection: $selectedTab) {
                
                HomeRootView(selectedTab: $selectedTab, viewModel: HomeFactory.makeHomeViewModel())
                    .tag(Tab.home)
                
                NavigationStack {
                    FavoriteView()
                }
                .tag(Tab.wishlist)
                
                NavigationStack {
                    CartRootView()
                }
                .tag(Tab.cart)
                
                SearchRootView()
                .tag(Tab.search)
                
                NavigationStack {
                    SettingsView()
                }
                .tag(Tab.settings)
            }
            .toolbar(.hidden, for: .tabBar)
            
            CustomTabBarView(selectedTab: $selectedTab)
        }
        .ignoresSafeArea(.keyboard)
    }
}

#Preview {
    @Previewable @State var networkMonitor = NetworkMonitor()
    TabBarView()
        .environment(networkMonitor)
}
