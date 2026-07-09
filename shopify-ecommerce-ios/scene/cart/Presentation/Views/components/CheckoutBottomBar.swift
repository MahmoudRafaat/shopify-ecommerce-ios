import SwiftUI

struct CheckoutBottomBar: View {
    @Environment(CartViewModel.self) var viewModel
    @Environment(CartCoordinator.self) private var coordinator
    @Environment(CurrencyService.self) private var currencyService
    
    var body: some View {
        HStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 4) {
                Text(PriceFormatter.format(amountString: viewModel.orderTotal, currencyService: currencyService))
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(AppColor.textPrimary)
                
                Button(action: {}) {
                    Text("View Details")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(Color("appPrimary"))
                }
            }
            
            Spacer()
            
            CustomButton(text: "Proceed to Payment") {
                guard let orderID = viewModel.draftOrderId else { return }
                coordinator.goToPayment(draftOrderId: orderID)
            }
            .disabled(viewModel.isLoading || viewModel.draftOrderId == nil)
            .padding(.trailing, 16)
        }
        .padding(.horizontal)
        .padding(.top, 16)
        .padding(.bottom, 16)
        .background(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(AppColor.backgroundPrimary)
                .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: -5)
        )
    }
}

#Preview {
    CheckoutBottomBar()
}
