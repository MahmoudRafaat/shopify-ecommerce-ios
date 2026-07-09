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

    @AppStorage(AppConstants.isGuestMode) private var isGuestMode = false
    @State private var showLoginAlert = false

    private let buttonHeight: CGFloat = 52

    var body: some View {

        HStack(spacing: 12) {

            // Cart Button
            Button(action: {
                if isGuestMode {
                    showLoginAlert = true
                } else {
                    onAddToCart()
                }
            }) {

                HStack(spacing: 10) {

                    RoundedRectangle(cornerRadius: 18)
                        .fill(AppColor.brandPrimary)
                        .frame(width: buttonHeight, height: buttonHeight)
                        .overlay {
                            Image(systemName: "cart")
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundStyle(AppColor.backgroundPrimary)
                        }

                    Text(state.cartTitle)
                        .font(.system(size: 17, weight: .regular))
                        .foregroundStyle(AppColor.backgroundPrimary)
//                        .lineLimit(1)

                    Spacer(minLength: 0)
                }
                .padding(.trailing, 18)
                .frame(width: 180, height: buttonHeight)
                .background(
                    LinearGradient(
                        colors: [
                            AppColor.brandPrimary,
                            AppColor.brandPrimary
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .clipShape(RoundedRectangle(cornerRadius: 18))
            }

            // Buy Now Button
            Button(action: {
                if isGuestMode {
                    showLoginAlert = true
                } else {
                    onBuyNow()
                }
            }) {

                HStack(spacing: 10) {

                    RoundedRectangle(cornerRadius: 18)
                        .fill(AppColor.successDefault)
                        .frame(width: buttonHeight, height: buttonHeight)
                        .overlay {
                            Image(systemName: "hand.tap")
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundStyle(AppColor.backgroundPrimary)
                        }

                    Text(state.buyTitle)
                        .font(.system(size: 17, weight: .regular))
                        .foregroundStyle(AppColor.backgroundPrimary)
                        .lineLimit(1)

                    Spacer(minLength: 0)
                }
                .padding(.trailing, 18)
                .frame(width: 180, height: buttonHeight)
                .background(
                    LinearGradient(
                        colors: [
                            AppColor.successDefault,
                            AppColor.successDefault
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .clipShape(RoundedRectangle(cornerRadius: 18))
            }
        }
        .alert("Login Required", isPresented: $showLoginAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Login Now") {
                isGuestMode = false
            }
        } message: {
            Text("Please login to access this feature.")
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
