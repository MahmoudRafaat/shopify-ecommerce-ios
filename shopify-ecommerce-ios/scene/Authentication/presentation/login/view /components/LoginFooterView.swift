//
//  Untitled.swift
//  shopify-ecommerce-ios
//
//  Created by Mahmoud Raafat Mustafa on 27/06/2026.
//
import SwiftUI
struct LoginFooterView: View {
    var onSignUp: () -> Void
    
    var body: some View {
        HStack(spacing: 4) {
            Text("Create An Account")
                .font(.subheadline)
                .foregroundColor(.gray)
            Button(action: onSignUp) {
                Text("Sign Up")
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundColor(.pink)
            }
        }
        .font(.footnote)
        .padding(.bottom, 20)
    }
}
