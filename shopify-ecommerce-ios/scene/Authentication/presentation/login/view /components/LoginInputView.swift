//
//  LoginInputView.swift
//  shopify-ecommerce-ios
//
//  Created by Mahmoud Raafat Mustafa on 27/06/2026.
//

import SwiftUI

struct LoginInputView: View {
    @Binding var email: String
    @Binding var password: String
    let errorMessage: String?
    
    @State private var showPassword = false
    
    var body: some View {
        VStack(spacing: 8) {
            // Email Field
            VStack(alignment: .leading, spacing: 4) {
                CustomTextField(
                    placeholder: "Email Address",
                    type: .email,
                    hasError: errorMessage?.contains("email") ?? false,
                    errorMessage: errorMessage?.contains("email") == true ? errorMessage : nil,
                    text: $email
                )
                .padding(.horizontal, -28)
            }
            
            // Password Field with visibility toggle
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    CustomTextField(
                        placeholder: "Password",
                        type: .password,
                        hasError: errorMessage?.contains("password") ?? false,
                        errorMessage: errorMessage?.contains("password") == true ? errorMessage : nil,
                        text: $password
                    )
                    .padding(.horizontal, -28)
                    
                }
            }
            
            Button(action: {
                // Forgot password action
            }) {
                Text("Forgot Password?")
                    .font(.footnote)
                    .foregroundColor(.pink)
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
            .padding(.top, 8)
        }
    }
}
