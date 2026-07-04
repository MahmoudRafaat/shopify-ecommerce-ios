//
//  SettingsProfileHeader.swift
//  shopify-ecommerce-ios
//
//  Created by Mahmoud Raafat Mustafa on 04/07/2026.
//

import SwiftUI




struct SettingsProfileHeader: View {
    let email: String
    let isLoggedIn: Bool
    
    var body: some View {
        HStack(spacing: 16) {
            Circle()
                .fill(isLoggedIn ? Color.pink.opacity(0.2) : Color.gray.opacity(0.2))
                .frame(width: 60, height: 60)
                .overlay {
                    Image(systemName: isLoggedIn ? "person.fill" : "person.slash.fill")
                        .font(.title2)
                        .foregroundStyle(isLoggedIn ? .pink : .gray)
                }
            
                Text(isLoggedIn ? email : "Sign in to manage your account")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            
            
            Spacer()
            
            if isLoggedIn {
                Image(systemName: "chevron.right")
                    .font(.footnote)
                    .foregroundColor(Color(.systemGray3))
            }
        }
        .padding(20)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: Color.black.opacity(0.03), radius: 10, x: 0, y: 5)
    }
}
