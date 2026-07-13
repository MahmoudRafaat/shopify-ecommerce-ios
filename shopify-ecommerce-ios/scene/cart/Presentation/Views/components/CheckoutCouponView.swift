import SwiftUI

struct CheckoutCouponView: View {
    @Environment(CartViewModel.self) var viewModel
    var onSelect: (() -> Void)? = nil
    
    var body: some View {
        HStack {
            Image(systemName: "ticket")
                .font(.title2)
                .foregroundColor(AppColor.textPrimary)
            
            if let selectedCouponCode = viewModel.uiState.selectedCouponCode {
                Text(selectedCouponCode)
                    .font(.body)
                    .fontWeight(.bold)
                    .foregroundColor(AppColor.textPrimary)
                
                Spacer()
                
                Button(action: {
                    Task {
                        await viewModel.removeDiscount()
                    }
                    viewModel.uiState.selectedCouponCode = nil
                    viewModel.uiState.selectedCoupon = nil
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(AppColor.textSecondary)
                }
            } else {
                Text("Apply Coupons")
                    .font(.body)
                    .foregroundColor(AppColor.textPrimary)
                
                Spacer()
                
                Button(action: {
                    viewModel.uiState.isCouponSheetPresented = true
                    onSelect?()
                }) {
                    Text("Select")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(Color("appPrimary"))
                }
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 16)
    }
}

#Preview {
    CheckoutCouponView()
}
