import SwiftUI

struct CheckoutDropdownView: View {
    var title: String
    var value: String
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Text(title)
                    .foregroundColor(AppColor.textSecondary)
                Text(value)
                    .foregroundColor(AppColor.textPrimary)
                Image(systemName: "chevron.down")
                    .foregroundColor(AppColor.textSecondary)
                    .font(.caption)
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(Color(.systemGray6))
            .cornerRadius(6)
        }
    }
}

#Preview {
    HStack {
        CheckoutDropdownView(title: "Size", value: "42", action: {})
        CheckoutDropdownView(title: "Qty", value: "1", action: {})
    }
}
