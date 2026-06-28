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
    
    var body: some View {
        VStack(spacing: 16) {
            TextField("Username or Email", text: $email)
                .padding()
                .background(Color(UIColor.systemGray6))
                .cornerRadius(10)
            
            TextField("Password", text: $password)
                .padding()
                .background(Color(UIColor.systemGray6))
                .cornerRadius(10)
            
            Button(action: {
                // Forgot password action
            }) {
                Text("Forgot Password?")
                    .font(.footnote)
                    .foregroundColor(.pink)
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
        }
    }
}
