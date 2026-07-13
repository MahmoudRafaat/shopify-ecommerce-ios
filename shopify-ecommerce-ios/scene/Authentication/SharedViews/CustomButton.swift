//
//  AuthCustomeButton.swift
//  shopify-ecommerce-ios
//
//  Created by Ehab Salah on 27/06/2026.
//

import SwiftUI

struct CustomButton: View {
    let text: String
    let action: () -> Void
    var body: some View {
        Button(action: action, label: {
            Text(text)
                .fontWeight(.semibold)
                .font(.system(size: 20))
                .foregroundColor(AppColor.backgroundPrimary)
                .frame(maxWidth: .infinity)
                .frame(height: 55)
                .background(Color.appPrimary)
                .cornerRadius(10)
        })
    }
}

#Preview {
    CustomButton(text: "Sign Up", action: {})
}
