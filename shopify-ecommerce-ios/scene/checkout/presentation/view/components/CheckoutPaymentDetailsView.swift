import SwiftUI

struct CheckoutPaymentDetailsView: View {
    @Environment(CheckoutViewModel.self) var viewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Order Payment Details")
                .font(.headline)
                .foregroundColor(.black)
                .padding(.bottom, 8)
            
            // Order Amounts
            CheckoutTextRowView(title: "Order Amounts", value: "\(viewModel.subtotal)")
            
            // Convenience
            HStack {
                HStack(spacing: 8) {
                    Text("Convenience")
                        .font(.subheadline)
                        .foregroundColor(.black)
                    
                    Button(action: {}) {
                        Text("Know More")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(Color("appPrimary"))
                    }
                }
                
                Spacer()
                
                Button(action: {}) {
                    Text("Apply Coupon")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(Color("appPrimary"))
                }
            }
            
            // Discount
            if viewModel.discountAmount != "0.00" {
                CheckoutTextRowView(title: "Discount", value: "-\(viewModel.discountAmount)", valueColor: .green)
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
