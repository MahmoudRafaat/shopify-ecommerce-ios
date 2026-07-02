//
//  CustomTabBarView.swift
//  shopify-ecommerce-ios
//
//  Created by albaraa alsayed on 13/01/1448 AH.
//

import SwiftUI

struct CustomTabBarView: View {
    @Binding var selectedTab: Tab
    
    // TODO: Change After Merge to Dev
    let themeRed : Color = .red
    
    var body: some View {
        HStack {
            ForEach(Tab.allCases, id: \.self) { tab in
                Spacer()
                Button {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        selectedTab = tab
                    }
                } label: {
                    if tab == .cart {
                        ZStack {
                            Circle()
                                .fill(selectedTab == .cart ? themeRed : Color.white)
                                .frame(width: 65, height: 65)
                                .shadow(color: .black.opacity(0.15), radius: 10, x: 0, y: 5)
                            
                            Image(systemName: tab.iconName(isActive: selectedTab == tab))
                                .font(.system(size: 26, weight: .medium))
                                .foregroundColor(selectedTab == .cart ? .white : .black)
                        }
                        .offset(y: -25)
                        
                    } else {
                        VStack(spacing: 4) {
                            Image(systemName: tab.iconName(isActive: selectedTab == tab))
                                .font(.system(size: 24))
                            
                            Text(tab.rawValue)
                                .font(.system(size: 12, weight: selectedTab == tab ? .medium : .regular))
                        }
                        .foregroundColor(selectedTab == tab ? themeRed : .black)
                    }
                }
                Spacer()
            }
        }
        .frame(height: 75)
        .background(Color.white)
        .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: -5)
    }
}

#Preview {
    CustomTabBarView(selectedTab: .constant(.home))
}
