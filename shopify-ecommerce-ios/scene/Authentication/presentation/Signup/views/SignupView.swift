//
//  SignupView.swift
//  shopify-ecommerce-ios
//
//  Created by Ehab Salah on 27/06/2026.
//

import SwiftUI

struct SignupView: View {
    @State private var emailOrUsername = ""
    @State private var password = ""
    @State private var isPasswordVisible = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            
            // MARK: - Header
            SignupHeader()
            // MARK: - Input Fields
            VStack(spacing: 20) {
                // Username or Email Field
                HStack(spacing: 12) {
                    Image(systemName: "person.fill")
                        .foregroundColor(.gray)
                    TextField("Username or Email", text: $emailOrUsername)
                        .font(.system(size: 16))
                }
                .padding()
                .background(Color(white: 0.96))
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                )
                
                // Password Field
                VStack(alignment: .trailing, spacing: 12) {
                    HStack(spacing: 12) {
                        Image(systemName: "lock.fill")
                            .foregroundColor(.gray)
                        
                        if isPasswordVisible {
                            TextField("Password", text: $password)
                        } else {
                            SecureField("Password", text: $password)
                        }
                        
                        Button(action: { isPasswordVisible.toggle() }) {
                            Image(systemName: isPasswordVisible ? "eye" : "eye.slash")
                                .foregroundColor(.gray)
                        }
                    }
                    .padding()
                    .background(Color(white: 0.96))
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                    )
                }
                // Confirm Password Field
                VStack(alignment: .trailing, spacing: 12) {
                    HStack(spacing: 12) {
                        Image(systemName: "lock.fill")
                            .foregroundColor(.gray)
                        
                        if isPasswordVisible {
                            TextField("Confirm Password", text: $password)
                        } else {
                            SecureField("Confirm Password", text: $password)
                        }
                        
                        Button(action: { isPasswordVisible.toggle() }) {
                            Image(systemName: isPasswordVisible ? "eye" : "eye.slash")
                                .foregroundColor(.gray)
                        }
                    }
                    .padding()
                    .background(Color(white: 0.96))
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                    )
                }
            }
            .padding(.top, 10)
            
            // MARK: - Login Button (Custom Button)
            CustomButton(text: "Create Account", action: {})
            // MARK: - Social Login Divider
            HStack() {
                Spacer()
                SocialLoginView(onGoogleTap: {}, onAppleTap: {}, onFacebookTap: {})
                Spacer()
            }
            // MARK: - Footer (Sign Up)
            SignupFooter()
        }
        .padding(.horizontal, 24)
        .background(Color.white.ignoresSafeArea())
    }
}

#Preview {
    SignupView()
}
