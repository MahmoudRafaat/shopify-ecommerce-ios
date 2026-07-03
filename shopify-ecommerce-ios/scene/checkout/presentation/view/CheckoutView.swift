//
//  CheckoutView.swift
//  shopify-ecommerce-ios
//
//  Created by Ehab Salah on 02/07/2026.
//

import SwiftUI

struct CheckoutView: View {
    @State private var viewModel = CheckoutViewModel()
    @Environment(\.presentationMode) var presentationMode
    
    // Product info passed from previous screen
    let lineItems: [DraftLineItemRequest]
    
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
            CheckoutBottomBar()
        }
        .environment(viewModel)
        .navigationBarHidden(true)
        .edgesIgnoringSafeArea(.bottom)
        .showLoading(if: viewModel.isLoading)
        .showCustomAlert(title: "Error", errorMessage: Bindable(viewModel).errorMessage)
        .task {
            await viewModel.createInitialDraftOrder(lineItems: lineItems)
        }
    }
}

#Preview {
    CheckoutView(lineItems: [DraftLineItemRequest(variantId: 0, quantity: 1)])
}
