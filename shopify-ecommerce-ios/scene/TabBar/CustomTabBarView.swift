//
//  CustomTabBarView.swift
//  shopify-ecommerce-ios
//
//  Created by albaraa alsayed on 13/01/1448 AH.
//

import SwiftUI

struct CustomTabBarView: View {
    @Binding var selectedTab: Tab
    @AppStorage(AppConstants.isGuestMode) private var isGuestMode = false
    @State private var showLoginAlert = false
    
    @State private var showNetworkAlert = false
    
    // TODO: Change After Merge to Dev
    let themeRed : Color = .appPrimary
    
    var body: some View {
        HStack {
            ForEach(Tab.allCases, id: \.self) { tab in
                Spacer()
                Button {
                    guard NetworkMonitor.shared.isConnected else {
                        showNetworkAlert = true
                        return
                    }
                    if isGuestMode && (tab == .cart || tab == .wishlist) {
                        showLoginAlert = true
                    } else {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            selectedTab = tab
                        }
                    }
                } label: {
                    if tab == .cart {
                        ZStack {
                            Circle()
                                .fill(selectedTab == .cart ? themeRed : AppColor.backgroundPrimary)
                                .frame(width: 65, height: 65)
                                .shadow(color: .black.opacity(0.15), radius: 10, x: 0, y: 5)
                            
                            Image(systemName: tab.iconName(isActive: selectedTab == tab))
                                .font(.system(size: 26, weight: .medium))
                                .foregroundColor(selectedTab == .cart ? AppColor.backgroundPrimary : AppColor.textPrimary)
                        }
                        .offset(y: -25)
                        
                    } else {
                        VStack(spacing: 4) {
                            Image(systemName: tab.iconName(isActive: selectedTab == tab))
                                .font(.system(size: 24))
                            
                            Text(tab.rawValue)
                                .font(.system(size: 12, weight: selectedTab == tab ? .medium : .regular))
                        }
                        .foregroundColor(selectedTab == tab ? themeRed : AppColor.textPrimary)
                    }
                }
                Spacer()
            }
        }
        .frame(height: 75)
        .background(AppColor.backgroundPrimary)
        .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: -5)
        .alert("Login Required", isPresented: $showLoginAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Login Now") {
                isGuestMode = false // This will route them back to the login screen
            }
        } message: {
            Text("Please login to access this feature.")
        }
        .alert("No Internet Connection", isPresented: $showNetworkAlert) {
            Button("Settings") {
                if let url = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(url)
                }
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("Please check your internet connection before continuing.")
        }
    }
}

#Preview {
    CustomTabBarView(selectedTab: .constant(.home))
}
