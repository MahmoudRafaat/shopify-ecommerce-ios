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
                
                HomeRootView(selectedTab: $selectedTab)
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
                    SearchView()
                }
                .tag(Tab.search)
                
                NavigationStack {
                    Text("Settings")
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
    @Previewable @State var networkMonitor = NetworkMonitor()
    TabBarView()
        .environment(networkMonitor)
}
