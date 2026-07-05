//
//  CheckoutViewBody.swift
//  shopify-ecommerce-ios
//
//  Created by Ehab Salah on 02/07/2026.
//

import SwiftUI

struct CheckoutViewBody: View {
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 24) {
                CheckoutProductItemView()
                
                Divider()
                    .padding(.horizontal)
                
                CheckoutCouponView(onSelect: {
                    // Handle coupon selection
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
