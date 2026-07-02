//
//  CustomAlertModifier.swift
//  shopify-ecommerce-ios
//
//  Created by Ehab Salah on 29/06/2026.
//

import SwiftUI

struct CustomAlertModifier: ViewModifier {
    let title: String
    @Binding var errorMessage: String?
    
    func body(content: Content) -> some View {
        content
            .alert(
                title,
                isPresented: Binding(
                    get: { errorMessage != nil },
                    set: { newValue in if !newValue { errorMessage = nil } }
                )
            ) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(errorMessage ?? "Unknown Error occurred.")
            }
    }
}


extension View {
    func showCustomAlert(title: String, errorMessage: Binding<String?>) -> some View {
        self.modifier(CustomAlertModifier(title: title, errorMessage: errorMessage))
    }
}
