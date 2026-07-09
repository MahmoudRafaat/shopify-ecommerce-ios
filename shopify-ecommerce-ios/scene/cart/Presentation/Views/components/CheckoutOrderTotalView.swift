import SwiftUI

struct CheckoutOrderTotalView: View {
    @Environment(CartViewModel.self) var viewModel
    @Environment(CurrencyService.self) private var currencyService
    
    var body: some View {
        VStack(spacing: 8) {
            CheckoutTextRowView(title: "Order Total", value: PriceFormatter.format(amountString: viewModel.uiState.orderTotal, currencyService: currencyService), font: .headline)
            
            HStack(spacing: 8) {
                Text("EMI Available")
                    .font(.subheadline)
                    .foregroundColor(AppColor.textPrimary)
                
                Button(action: {}) {
                    Text("Details")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(Color("appPrimary"))
                }
                
                Spacer()
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 16)
    }
}

#Preview {
    CheckoutOrderTotalView()
}
