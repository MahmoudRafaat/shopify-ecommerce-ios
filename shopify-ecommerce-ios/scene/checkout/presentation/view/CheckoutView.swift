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
    var products: [ProductDataModel] 
    
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
            
            if viewModel.isOrderDeleted || viewModel.cartLineItems.isEmpty && viewModel.draftOrderId == nil && !viewModel.isLoading {
                // Empty State
                EmptyCartView(onGoBack: {
                    presentationMode.wrappedValue.dismiss()
                })
            } else {
                // Checkout Content Body
                CheckoutViewBody()
                
                // Bottom Sticky Bar
                CheckoutBottomBar()
            }
        }
        .environment(viewModel)
        .navigationBarHidden(true)
        .edgesIgnoringSafeArea(.bottom)
        .showLoading(if: viewModel.isLoading)
        .showCustomAlert(title: "Error", errorMessage: Bindable(viewModel).errorMessage)
        .sheet(isPresented: Bindable(viewModel).isAddressSheetPresented) {
            AddAddressSheet()
                .environment(viewModel)
        }
        .sheet(isPresented: Bindable(viewModel).isCouponSheetPresented) {
            SelectCouponSheet()
                .environment(viewModel)
        }
        .task {
            await viewModel.loadOrCreateCart(products: products)
        }
    }
}

#Preview {
    CheckoutView(products: [
        ProductDataModel(variantId: 46128795517064, quantity: 1, imageUrl: nil),
        ProductDataModel(variantId: 8955349303432, quantity: 2, imageUrl: nil)
    ])
}
