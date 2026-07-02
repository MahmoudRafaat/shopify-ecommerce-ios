import SwiftUI

struct CheckoutOrderTotalView: View {
    var body: some View {
        VStack(spacing: 8) {
            CheckoutTextRowView(title: "Order Total", value: "₹ 7,000.00", font: .headline)
            
            HStack(spacing: 8) {
                Text("EMI Available")
                    .font(.subheadline)
                    .foregroundColor(.black)
                
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
