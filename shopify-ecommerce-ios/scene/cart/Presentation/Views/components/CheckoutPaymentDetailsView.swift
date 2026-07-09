import SwiftUI

struct CheckoutPaymentDetailsView: View {
    @Environment(CartViewModel.self) var viewModel
    @Environment(CurrencyService.self) private var currencyService
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Order Payment Details")
                .font(.headline)
                .foregroundColor(AppColor.textPrimary)
                .padding(.bottom, 8)
            
            // Order Amounts
            CheckoutTextRowView(title: "Order Amounts", value: PriceFormatter.format(amountString: viewModel.uiState.originalSubtotal, currencyService: currencyService))
            
            // Convenience
            HStack {
                HStack(spacing: 8) {
                    Text("Convenience")
                        .font(.subheadline)
                        .foregroundColor(AppColor.textPrimary)
                    
                    Button(action: {}) {
                        Text("Know More")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(Color("appPrimary"))
                    }
                }
                
                Spacer()
                
                Button(action: {
                    Task {
                        await viewModel.applyDiscount()
                    }
                }) {
                    Text("Apply Coupon")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(viewModel.uiState.selectedCouponCode == nil ? AppColor.textSecondary : Color("appPrimary"))
                }
                .disabled(viewModel.uiState.selectedCouponCode == nil)
            }
            
            // Discount
            if viewModel.uiState.discountAmount != "0.00" {
                CheckoutTextRowView(title: "Discount (\(viewModel.uiState.selectedCouponCode ?? ""))", value: "-\(PriceFormatter.format(amountString: viewModel.uiState.discountAmount, currencyService: currencyService))", valueColor: AppColor.successDefault)
            }
            
            // Delivery Fee
            CheckoutTextRowView(title: "Delivery Fee", value: "Free", valueColor: Color("appPrimary"))
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
    }
}

#Preview {
    CheckoutPaymentDetailsView()
}
