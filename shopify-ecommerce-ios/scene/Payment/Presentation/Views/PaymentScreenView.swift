//
//  PaymentScreenView.swift
//  shopify-ecommerce-ios
//
//  Created by albaraa alsayed on 18/01/1448 AH.
//

import SwiftUI

struct PaymentScreenView: View {

    let viewModel: PaymentViewModel
    /// Injected by CartRootView — called after a successful order to navigate to the success screen.
    /// Optional so the view works standalone in previews.
    var onOrderSuccess: (() -> Void)? = nil
    
    @Environment(CurrencyService.self) private var currencyService

    @State private var selectedIndex: Int = 0

    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(alignment: .leading, spacing: 28) {

                    // MARK: Price Summary
                    VStack(spacing: 18) {
                        titleWithPrice(title: "Subtotal",     price: PriceFormatter.format(amountString: viewModel.totalPrice, currencyService: currencyService), color: AppColor.textSecondary)
                        titleWithPrice(title: "Shipping",     price: "Free", color: AppColor.textSecondary)
                        Divider()
                        titleWithPrice(title: "Order Total",  price: PriceFormatter.format(amountString: viewModel.totalPrice, currencyService: currencyService), color: .primary)
                    }

                    Divider()

                    // MARK: Payment Methods
                    Text("Payment Method")
                        .font(.system(size: 18, weight: .bold))

                    ForEach(0..<viewModel.paymentMethods.count, id: \.self) { index in
                        paymentButton(
                            title: viewModel.paymentMethods[index].numbers,
                            icon:  viewModel.paymentMethods[index].icon,
                            index: index
                        )
                    }
                }
                .padding(24)
            }

            // MARK: Checkout Button
            CustomButton(text: "Checkout") {
                Task {
                    await viewModel.checkout(selectedIndex: selectedIndex)
                }
            }
            .padding(24)
            .padding(.bottom, 50) // Pad for tab bar
        }
        .task {
            await viewModel.getTotalPrice()
        }
        .showLoading(if: viewModel.uiState.isLoading)
        .onChange(of: viewModel.uiState.error) { _, error in
            if let error = error {
                AlertManager.shared.showError(error)
                viewModel.uiState.error = nil
            }
        }
        .onChange(of: viewModel.uiState.orderCompleted) { _, completed in
            if completed {
                onOrderSuccess?()
            }
        }
    }

    // MARK: - Helpers

    private func titleWithPrice(title: String, price: String, color: Color) -> some View {
        HStack {
            Text(title)
                .font(.system(size: 18, weight: .medium))
                .foregroundStyle(color)
            Spacer()
            Text(price)
                .font(.system(size: 18, weight: .medium))
                .foregroundStyle(color)
        }
    }

    private func paymentButton(title: String, icon: String, index: Int) -> some View {
        HStack {
            Image(icon)
            Spacer()
            Text(title)
                .font(.system(size: 18, weight: .medium))
                .foregroundStyle(AppColor.textSecondary)
        }
        .frame(height: 40)
        .padding(20)
        .overlay {
            RoundedRectangle(cornerRadius: 12)
                .stroke(
                    selectedIndex == index ? Color.appPrimary : Color.clear,
                    lineWidth: 1
                )
        }
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.appGray)
        )
        .onTapGesture {
            selectedIndex = index
        }
    }
}

#Preview {
    PaymentScreenView(viewModel: PaymentFactory.makePaymentViewModel(orderID: 1076599390344))
}
