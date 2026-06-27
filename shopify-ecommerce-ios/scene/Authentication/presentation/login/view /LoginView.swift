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
            VStack(alignment: .leading, spacing: 8) {
                Text("Welcome")
                Text("Back!")
            }
            .font(.system(size: 40, weight: .bold))
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.top, 40)
            .padding(.bottom, 20)
            
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
                }) {
                    Text("Forgot Password?")
                        .font(.footnote)
                        .foregroundColor(.pink)
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
            }
            
     
        }
        .padding(.horizontal, 24)
    }
}

#Preview {
    LoginView()
}
