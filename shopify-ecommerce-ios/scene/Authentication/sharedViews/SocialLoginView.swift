//
//  SoicalMediaButtons.swift
//  shopify-ecommerce-ios
//
//  Created by Mahmoud Raafat Mustafa on 27/06/2026.
//

import SwiftUI


struct SocialLoginView: View {
    var body: some View {
        VStack(spacing: 20) {
            Text("- OR Continue with -")
                .font(.subheadline)
                .foregroundColor(.secondary)
            HStack(spacing: 24) {
                SocialCircularButton(iconName: "google_logo") {
                    print("Google Tapped")
                }
                SocialCircularButton(iconName: "applelogo", isSystemImage: true) {
                    print("Apple Tapped")
                }
                SocialCircularButton(iconName: "facebook_logo") {
                    print("Facebook Tapped")
                }
            }
        }
        .padding()
    }
}

struct SocialCircularButton: View {
    let iconName: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Group {
                if isSystemImage {
                    Image(systemName: iconName)
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.black)
                } else {
                    Image(iconName)
                        .resizable()
                        .scaledToFit()
                }
            }
            .frame(width: 24, height: 24)
            .padding(18)
            .background(Color(red: 0.98, green: 0.95, blue: 0.96)) // Light pinkish background
            .clipShape(Circle())
            .overlay(
                Circle()
                    .stroke(Color(red: 1.0, green: 0.3, blue: 0.4), lineWidth: 1.5) // Red border
            )
        }
    }
}

#Preview {
    SocialLoginView()
}
