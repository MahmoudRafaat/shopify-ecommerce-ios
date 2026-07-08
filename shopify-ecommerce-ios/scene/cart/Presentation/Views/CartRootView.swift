//
//  CartRootView.swift
//  shopify-ecommerce-ios
//
//  Created by Yomna on 07/07/2026.
//

import SwiftUI

struct CartRootView: View {

    @State private var coordinator = CartCoordinator()

    var body: some View {
        NavigationStack(path: $coordinator.navigationPath) {

            CartView()
                .environment(coordinator)
                .navigationDestination(for: CartCoordinator.Destination.self) { destination in

                    switch destination {

                    case .payment(let draftOrderId):
                        PaymentScreenView(
                            viewModel: PaymentFactory.makePaymentViewModel(orderID: draftOrderId),
                            onOrderSuccess: {
                                // Cart is cleared inside PaymentViewModel.checkout() before
                                // this closure fires, so we just drive navigation here.
                                coordinator.goToSuccess()
                            }
                        )
                        .navigationTitle(Text("Payment"))

                    case .orderSuccess:
                        OrderSuccessView()
                            .environment(coordinator)
                    }
                }
        }
    }
}
