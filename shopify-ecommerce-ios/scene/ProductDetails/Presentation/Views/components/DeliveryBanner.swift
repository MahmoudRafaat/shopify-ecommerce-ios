//
//  DeliveryBanner.swift
//  shopify-ecommerce-ios
//
//  Created by Yomna on 03/07/2026.
//

import SwiftUI

struct DeliveryBanner: View {

    let state: DeliveryBannerState

    var body: some View {

        HStack(spacing: 16) {
            VStack(
                alignment: .leading,
                spacing: 4
            ) {

                Text(state.title)
                    .font(.subheadline)
                    .foregroundStyle(.black)

                Text(state.subtitle)
                    .fontWeight(.bold)
                    .foregroundStyle(.black)
            }

            Spacer()
        }
        .padding()
        .background(
            Color("appPink").opacity(0.2)
        )
        .clipShape(
            RoundedRectangle(cornerRadius: 20)
        )
    }
}
//#Preview {
//    DeliveryBanner()
//}
