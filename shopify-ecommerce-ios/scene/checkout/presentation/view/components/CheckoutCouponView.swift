import SwiftUI

struct CheckoutCouponView: View {
    var onSelect: (() -> Void)? = nil
    
    var body: some View {
        HStack {
            Image(systemName: "ticket")
                .font(.title2)
                .foregroundColor(.black)
            
            Text("Apply Coupons")
                .font(.body)
                .foregroundColor(.black)
            
            Spacer()
            
            Button(action: {
                onSelect?()
            }) {
                Text("Select")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(Color("appPrimary")) // Using the asset color
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 16)
    }
}

#Preview {
    CheckoutCouponView()
}
