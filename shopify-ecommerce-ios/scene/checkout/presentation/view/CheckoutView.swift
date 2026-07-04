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
            HStack(spacing: 12){
                AddressView(address: "216 St Paul's Rd, London N1 2LL, UK", contact: "+44-784232", editAction: {})
                AddButtonView(action: {})
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            
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
