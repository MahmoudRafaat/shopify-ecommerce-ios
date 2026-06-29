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
    
    @State private var emailHasError = false
    @State private var passwordHasError = false
    
    var body: some View {
        VStack(spacing: 8) {
            
            CustomTextField(
                placeholder: "Username or Email",
                type: .email,
                hasError: emailHasError,
                errorMessage: "Please enter a valid email.",// should be cahnged  for the specfic error message
                text: $email
            )
            //this line should be remvoed when delete the padding in the CustomTextField
            .padding(.horizontal, -28)
            
            CustomTextField(
                placeholder: "Password",
                type: .password,
                hasError: passwordHasError,
                errorMessage: "Password cannot be empty.", // should be cahnged  for the specfic error message
                text: $password
            )
            //this line should be remvoed when delete the padding in the CustomTextField
            .padding(.horizontal, -28)
            
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
