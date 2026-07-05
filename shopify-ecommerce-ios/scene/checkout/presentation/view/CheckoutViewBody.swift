//
//  CheckoutViewBody.swift
//  shopify-ecommerce-ios
//
//  Created by Ehab Salah on 02/07/2026.
//

import SwiftUI

struct CheckoutViewBody: View {
    @Environment(CheckoutViewModel.self) var viewModel
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 24) {

                AddressSection()
                
                ForEach(viewModel.cartLineItems) { item in
                    CheckoutProductItemView(item: item)
                }
                
                Divider()
                    .padding(.horizontal)
                
                CheckoutCouponView(onSelect: {
                    // Dismiss coupon execution for now
                })
                
                Divider()
                    .padding(.horizontal)
                
                CheckoutPaymentDetailsView()
                
                Divider()
                    .padding(.horizontal)
                
                CheckoutOrderTotalView()
            }
            .padding(.bottom, 20)
        }
    }
}

#Preview {
    CheckoutViewBody()
}
