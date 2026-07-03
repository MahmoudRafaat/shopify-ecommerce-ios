//
//  SettingsView.swift
//  shopify-ecommerce-ios
//
//  Created by Mahmoud Raafat Mustafa on 02/07/2026.
//


import SwiftUI

struct SettingsView: View {
    @State private var pushNotificationsEnabled = true
    @State private var darkThemeEnabled = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    
                    ProfileHeaderView(
                        name: "Mahmoud Raafat",
                        email: "mahmoud@example.com"
                    )
                    .padding(.horizontal, 20)
                    .padding(.top, 10)
                    
                    SettingsGroup {
                        SettingsRowView(icon: "map.fill", title: "Shipping Addresses")
                        Divider().padding(.leading, 60)
                        SettingsRowView(icon: "creditcard.fill", title: "Payment Methods")
                        Divider().padding(.leading, 60)
                        SettingsRowView(icon: "bag.fill", title: "My Orders")
                        
                    
                    }
                    
                    SettingsGroup {
                        SettingsRowView(
                            icon: "bell.fill",
                            title: "Notifications",
                            style: .toggle($pushNotificationsEnabled)
                        )
                        Divider().padding(.leading, 60)
                        SettingsRowView(icon: "globe", title: "Language")
                        Divider().padding(.leading, 60)
                        SettingsRowView(
                            icon: "moon.fill",
                            title: "Dark Theme",
                            style: .toggle($darkThemeEnabled)
                        )
                    }
                    
                    SettingsGroup {
                        SettingsRowView(icon: "lock.fill", title: "Change Password")
                        Divider().padding(.leading, 60)
                        SettingsRowView(icon: "questionmark.circle.fill", title: "Help Center")
                    }
                    
                    SettingsGroup {
                        Button {
                            // Trigger View Model Log Out
                        } label: {
                            SettingsRowView(
                                icon: "rectangle.portrait.and.arrow.right",
                                title: "Log Out",
                                style: .destructive
                            )
                        }
                    }
                    
                    Spacer(minLength: 40)
                }
            }
            .background(Color(white: 0.98).ignoresSafeArea())
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct SettingsGroup<Content: View>: View {
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        VStack(spacing: 0) {
            content
        }
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: Color.black.opacity(0.02), radius: 8, x: 0, y: 4)
        .padding(.horizontal, 20)
    }
}

#Preview {
    SettingsView()
}
