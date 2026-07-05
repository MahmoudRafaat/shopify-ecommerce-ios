//
//  ProductActionButtons.swift
//  shopify-ecommerce-ios
//
//  Created by Yomna on 03/07/2026.
//

import SwiftUI

struct ProductActionButtons: View {

    let state: ProductActionsState

    let onAddToCart: () -> Void
    let onBuyNow: () -> Void

    private let buttonHeight: CGFloat = 52

    var body: some View {

        HStack(spacing: 12) {

            // Cart Button
            Button(action: onAddToCart) {

                HStack(spacing: 10) {

                    RoundedRectangle(cornerRadius: 18)
                        .fill(Color(red: 0.04, green: 0.30, blue: 0.82))
                        .frame(width: buttonHeight, height: buttonHeight)
                        .overlay {
                            Image(systemName: "cart")
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundStyle(.white)
                        }

                    Text(state.cartTitle)
                        .font(.system(size: 17, weight: .regular))
                        .foregroundStyle(.white)
//                        .lineLimit(1)

                    Spacer(minLength: 0)
                }
                .padding(.trailing, 18)
                .frame(width: 180, height: buttonHeight)
                .background(
                    LinearGradient(
                        colors: [
                            Color(red: 0.16, green: 0.45, blue: 0.95),
                            Color(red: 0.08, green: 0.33, blue: 0.90)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .clipShape(RoundedRectangle(cornerRadius: 18))
            }

            // Buy Now Button
            Button(action: onBuyNow) {

                HStack(spacing: 10) {

                    RoundedRectangle(cornerRadius: 18)
                        .fill(Color(red: 0.02, green: 0.62, blue: 0.28))
                        .frame(width: buttonHeight, height: buttonHeight)
                        .overlay {
                            Image(systemName: "hand.tap")
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundStyle(.white)
                        }

                    Text(state.buyTitle)
                        .font(.system(size: 17, weight: .regular))
                        .foregroundStyle(.white)
                        .lineLimit(1)

                    Spacer(minLength: 0)
                }
                .padding(.trailing, 18)
                .frame(width: 180, height: buttonHeight)
                .background(
                    LinearGradient(
                        colors: [
                            Color(red: 0.42, green: 0.88, blue: 0.55),
                            Color(red: 0.30, green: 0.80, blue: 0.45)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .clipShape(RoundedRectangle(cornerRadius: 18))
            }
        }
    }
}

#Preview {
    ProductActionButtons(
        state: ProductActionsState(cartTitle: "Go to cart", buyTitle: "Buy Now"),
        onAddToCart: {},
        onBuyNow: {}
    )
    .padding()
}
