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

    var body: some View {

        HStack(spacing: 12) {

            // Cart Button
            Button(action: onAddToCart) {

                HStack(spacing: 12) {

                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color.blue.opacity(0.9),
                                    Color.blue.opacity(0.7)
                                ],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .frame(width: 46, height: 46)
                        .overlay {
                            Image(systemName: "cart")
                                .font(.title3)
                                .foregroundStyle(.white)
                        }

                    Text(state.cartTitle)
                        .font(.title3.weight(.medium))
                        .foregroundStyle(.white)

                    Spacer()
                }
                .padding(.horizontal, 10)
                .frame(maxWidth: .infinity)
                .frame(height: 56)
                .background(
                    LinearGradient(
                        colors: [
                            Color("appBlue"),
                            Color("appBlue").opacity(0.8)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .clipShape(
                    RoundedRectangle(cornerRadius: 28)
                )
            }

            // Buy Now Button
            Button(action: onBuyNow) {

                HStack(spacing: 12) {

                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color.green.opacity(0.9),
                                    Color.green.opacity(0.7)
                                ],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .frame(width: 46, height: 46)
                        .overlay {
                            Image(systemName: "hand.tap")
                                .font(.title3)
                                .foregroundStyle(.white)
                        }

                    Text(state.buyTitle)
                        .font(.title3.weight(.medium))
                        .foregroundStyle(.white)

                    Spacer()
                }
                .padding(.horizontal, 10)
                .frame(maxWidth: .infinity)
                .frame(height: 56)
                .background(
                    LinearGradient(
                        colors: [
                            Color.green.opacity(0.9),
                            Color.green.opacity(0.75)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .clipShape(
                    RoundedRectangle(cornerRadius: 28)
                )
            }
        }
    }
}

//#Preview {
//    ProductActionButtons()
//}
