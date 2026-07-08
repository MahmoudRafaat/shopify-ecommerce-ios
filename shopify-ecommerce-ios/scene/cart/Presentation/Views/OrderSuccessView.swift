//
//  OrderSuccessView.swift
//  shopify-ecommerce-ios
//

import SwiftUI

/// Shown after a successful order is placed (Paymob or Cash on Delivery).
/// Clears the cart and gives the user a way back to shopping.
struct OrderSuccessView: View {
    @Environment(CartCoordinator.self) private var coordinator

    var body: some View {
        VStack(spacing: 32) {
            Spacer()

            Image(systemName: "checkmark.seal.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 90, height: 90)
                .foregroundColor(Color("appPrimary"))

            VStack(spacing: 12) {
                Text("Order Placed!")
                    .font(.title)
                    .fontWeight(.bold)

                Text("Your order has been placed successfully.\nWe'll notify you when it ships.")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
            }

            Spacer()

            CustomButton(text: "Continue Shopping") {
                coordinator.popToRoot()
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 32)
        }
        .navigationBarHidden(true)
        // Cart is cleared by the ViewModel before navigating here.
    }
}

#Preview {
    OrderSuccessView()
        .environment(CartCoordinator())
}

