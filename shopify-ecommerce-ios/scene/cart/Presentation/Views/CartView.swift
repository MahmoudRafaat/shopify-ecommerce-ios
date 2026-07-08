//
//  CheckoutView.swift
//  shopify-ecommerce-ios
//
//  Created by Ehab Salah on 02/07/2026.
//

import SwiftUI

struct CartView: View {
    @State private var viewModel = CartFactory.makeCartViewModel()
    @Environment(\.presentationMode) var presentationMode
    @State private var showHome = false
    
    var products: [ProductDataModel] = CartService.shared.products
    
    var body: some View {
        VStack(spacing: 0) {
            // Navigation Bar
            CheckoutNavigationBar()
            
            if viewModel.isOrderDeleted || viewModel.cartLineItems.isEmpty && viewModel.draftOrderId == nil && !viewModel.isLoading {
                // Empty State
                EmptyCartView(onGoBack: {
                    showHome = true
                })
            } else {
                CartViewBody()
                CheckoutBottomBar()
                    .padding(.bottom, 75)
            }
        }
        .environment(viewModel)
        .navigationBarHidden(true)
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
            await viewModel.loadOrCreateCart(products: CartService.shared.products)
        }
        .fullScreenCover(isPresented: $showHome) {
            TabBarView()
        }
    }
}

#Preview {
    CartView(products: [
        ProductDataModel(variantId: 46128795517064, quantity: 1, imageUrl: nil),
        ProductDataModel(variantId: 8955349303432, quantity: 2, imageUrl: nil)
    ])
}
