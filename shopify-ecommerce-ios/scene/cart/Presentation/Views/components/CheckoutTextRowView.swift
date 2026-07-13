import SwiftUI

struct CheckoutTextRowView: View {
    var title: String
    var value: String
    var valueColor: Color = AppColor.textPrimary
    var isBoldValue: Bool = true
    var font: Font = .subheadline
    
    var body: some View {
        HStack {
            Text(title)
                .font(font)
                .foregroundColor(AppColor.textPrimary)
            
            Spacer()
            
            Text(value)
                .font(font)
                .fontWeight(isBoldValue ? .bold : .semibold)
                .foregroundColor(valueColor)
        }
    }
}

#Preview {
    VStack {
        CheckoutTextRowView(title: "Order Amounts", value: "₹ 7,000.00")
        CheckoutTextRowView(title: "Delivery Fee", value: "Free", valueColor: Color("appPrimary"))
    }
}
