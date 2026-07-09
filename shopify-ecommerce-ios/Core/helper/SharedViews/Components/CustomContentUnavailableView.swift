//
//  CustomContentUnavailableView.swift
//  shopify-ecommerce-ios
//

import SwiftUI

struct CustomContentUnavailableView: View {
    let error: AppError
    let onRetry: () -> Void
    
    var body: some View {
        ContentUnavailableView {
            Label(error.title, systemImage: error.icon)
        } description: {
            Text(error.message)
        } actions: {
            Button("Try Again") {
                onRetry()
            }
            .buttonStyle(.borderedProminent)
            .tint(.appBlue)
            .controlSize(.regular)
        }
    }
}

#Preview {
    CustomContentUnavailableView(error: .noInternet, onRetry: {})
}
