//
//  CheckoutView.swift
//  shopify-ecommerce-ios
//
//  Created by Ehab Salah on 02/07/2026.
//

import SwiftUI

struct CheckoutView: View {
    @StateObject private var viewModel = CheckoutViewModel()
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack(spacing: 0) {
            // Navigation Bar
            CheckoutNavigationBar(
                onBack: {
                    presentationMode.wrappedValue.dismiss()
                },
                onWishlist: {
                    // Handle wishlist action
                }
            )
            
            // Checkout Content Body
            CheckoutViewBody()
            
            // Bottom Sticky Bar
            CheckoutBottomBar(onProceedToPayment: {
                viewModel.proceedToPayment()
            })
        }
        .navigationBarHidden(true)
        .edgesIgnoringSafeArea(.bottom)
    }
}

#Preview {
    CheckoutView()
}
