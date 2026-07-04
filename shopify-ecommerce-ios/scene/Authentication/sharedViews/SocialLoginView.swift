//
//  SoicalMediaButtons.swift
//  shopify-ecommerce-ios
//
//  Created by Mahmoud Raafat Mustafa on 27/06/2026.
//

import SwiftUI


struct SocialLoginView: View {
    var onGoogleTap: () -> Void
        var onAppleTap: () -> Void
        var onFacebookTap: () -> Void
    var body: some View {
        VStack(spacing: 20) {
            Text("- OR Continue with -")
                .font(.subheadline)
                .foregroundColor(.secondary)
            HStack(spacing: 10) {
                SocialCircularButton(iconName: "google",action: onGoogleTap)
                SocialCircularButton(iconName: "apple",action: onAppleTap)
                SocialCircularButton(iconName: "facebook", action: onFacebookTap)
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
                    Image(iconName)
                        .resizable()
                        .scaledToFit()
            }
            .frame(width: 24, height: 24)
            .padding(18)
            .background(Color(red: 0.98, green: 0.95, blue: 0.96))
            .clipShape(Circle())
            .overlay(
                Circle()
                    .stroke(Color(red: 1.0, green: 0.3, blue: 0.4), lineWidth: 1.5)
            )
        }
    }
}

#Preview {
    SocialLoginView(onGoogleTap: {print("google tapped")}, onAppleTap: {print("apple tapped")}, onFacebookTap: {print("facebook tapped")})
}
