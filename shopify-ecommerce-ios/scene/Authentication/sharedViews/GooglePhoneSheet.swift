//
//  GooglePhoneSheet.swift
//  shopify-ecommerce-ios
//
//  Created by Ehab Salah on 08/07/2026.
//

import SwiftUI

struct GooglePhoneSheet: View {
    @Binding var viewmodel: LoginViewModelProtocol
    var body: some View {
        VStack(spacing: 24) {
            Text("Complete Profile")
                .font(.title2)
                .fontWeight(.bold)
                .padding(.top, 24)
            
            Text("Please enter your phone number to complete the registration.")
                .font(.subheadline)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            CustomTextField(
                placeholder: "Phone Number",
                type: .phone,
                hasError: false,
                text: $viewmodel.googlePhone
            )
            
            CustomButton(text: "Submit") {
                viewmodel.submitGooglePhone()
            }
            .padding(.top, 16)
            
            Spacer()
        }
        .padding()
        .presentationDetents([.medium])
    }
}

#Preview {
//    GooglePhoneSheet(viewmodel: )
}
