import SwiftUI

struct CheckoutBottomBar: View {
    var onProceedToPayment: (() -> Void)? = nil
    
    var body: some View {
        HStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 4) {
                Text("₹ 7,000.00")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                
                Button(action: {}) {
                    Text("View Details")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(Color("appPrimary"))
                }
            }
            
            Spacer()
            
            CustomButton(text: "Proceed to Payment"){
                // handle payment action
            }
            .padding(.trailing, 16)
        }
        .padding(.horizontal)
        .padding(.top, 16)
        .padding(.bottom, 32)
        .background(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: -5)
        )
    }
}

#Preview {
    CheckoutBottomBar()
}
