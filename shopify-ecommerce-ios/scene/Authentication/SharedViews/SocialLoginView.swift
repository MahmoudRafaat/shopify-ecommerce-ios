//
//  SocialMediaButtons.swift
//  shopify-ecommerce-ios
//
//  Created by Mahmoud Raafat Mustafa on 27/06/2026.
//

import SwiftUI

struct SocialLoginView: View {
    var onGoogleTap: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            HStack {
                Spacer()
                Text("- OR Continue with -")
                    .font(.caption2)
                    .bold()
                    .foregroundColor(.secondary)
                Spacer()
            }
            

            GoogleWideButton(action: onGoogleTap)
        }
        .padding()
    }
}

struct VLine: View {
    var body: some View {
        Rectangle()
            .frame(height: 1)
            .foregroundColor(Color(.systemGray5))
    }
}

struct GoogleWideButton: View {
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image("google")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 22, height: 22)
                
                Text("Sign in with Google")
                    .font(.headline)
                    .fontWeight(.medium)
                    .foregroundColor(.black)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .background(Color.white)
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.08), radius: 6, x: 0, y: 3)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color(.systemGray4), lineWidth: 0.8)
            )
        }
    }
}

#Preview {
    ZStack {
        Color(.systemGroupedBackground) 
            .ignoresSafeArea()
        
        SocialLoginView(onGoogleTap: { print("google tapped") })
    }
}
