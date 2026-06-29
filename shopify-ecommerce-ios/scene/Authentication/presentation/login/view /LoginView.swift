//
//  LoginView.swift
//  shopify-ecommerce-ios
//
//  Created by Mahmoud Raafat Mustafa on 27/06/2026.
//

import SwiftUI

struct LoginView: View {
    @State private var email = ""
    @State private var password = "" 
    var body: some View {
        VStack(spacing: 24) {
            LoginHeaderView()
            LoginInputView(email: $email, password: $password)
            VStack(spacing: 16) {
                CustomButton(text: "Login") {
                    // Login action here
                }
                Button(action: {
                    // Guest login action here
                }) {
                    Text("Continue as Guest")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
            }
            .padding(.top, 10)
            Spacer()
            SocialLoginView(onGoogleTap: {}, onAppleTap: {}, onFacebookTap: {})
            Spacer()
            LoginFooterView(
                onSignUp: {
                    // Handle navigation to sign up
                }
            )
        }
        .padding(.horizontal, 24)
    }
}
#Preview {
    LoginView()
}
