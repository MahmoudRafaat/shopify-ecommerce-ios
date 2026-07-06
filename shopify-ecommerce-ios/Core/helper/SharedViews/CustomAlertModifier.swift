//
//  CustomAlertModifier.swift
//  shopify-ecommerce-ios
//
//  Created by Ehab Salah on 29/06/2026.
//

import SwiftUI

struct CustomAlertModifier: ViewModifier {
    let title: String
    @Binding var message: String?
    
    func body(content: Content) -> some View {
        content
            .alert(
                title,
                isPresented: Binding(
                    get: { message != nil },
                    set: { newValue in if !newValue { message = nil } }
                )
            ) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(message ?? "Unknown Error occurred.")
            }
    }
}


extension View {
    func showCustomAlert(title: String, errorMessage: Binding<String?>) -> some View {
        self.modifier(CustomAlertModifier(title: title, message: errorMessage))
    }
}
