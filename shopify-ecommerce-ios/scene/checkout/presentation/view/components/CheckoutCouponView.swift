import SwiftUI

struct CheckoutCouponView: View {
    @Environment(CheckoutViewModel.self) var viewModel
    var onSelect: (() -> Void)? = nil
    
    var body: some View {
        HStack {
            Image(systemName: "ticket")
                .font(.title2)
                .foregroundColor(.black)
            
            if let selectedCouponCode = viewModel.selectedCouponCode {
                Text(selectedCouponCode)
                    .font(.body)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                
                Spacer()
                
                Button(action: {
                    Task {
                        await viewModel.removeDiscount()
                    }
                    viewModel.selectedCouponCode = nil
                    viewModel.selectedCoupon = nil
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                }
            } else {
                Text("Apply Coupons")
                    .font(.body)
                    .foregroundColor(.black)
                
                Spacer()
                
                Button(action: {
                    viewModel.isCouponSheetPresented = true
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
