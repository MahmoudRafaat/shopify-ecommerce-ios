//
//  EmptyCartView.swift
//  shopify-ecommerce-ios
//
//  Created by Ehab Salah on 04/07/2026.
//

import SwiftUI

struct EmptyCartView: View {
    let onGoBack: () -> Void
    
    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            
            Image(systemName: "cart.badge.minus")
                .font(.system(size: 80))
                .foregroundColor(.gray.opacity(0.5))
            
            Text("Your bag is empty")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.black)
            
            Text("Looks like you haven't added any items to your bag yet.")
                .font(.subheadline)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            
            CustomButton(text: "Continue Shopping") {
                onGoBack()
            }
            .padding(.horizontal, 28)
            .padding(.top, 16)
            
            Spacer()
        }
    }
}

#Preview {
    EmptyCartView(onGoBack: {})
}
