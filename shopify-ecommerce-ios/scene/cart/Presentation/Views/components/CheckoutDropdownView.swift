import SwiftUI

struct CheckoutDropdownView: View {
    var title: String
    var value: String
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Text(title)
                    .foregroundColor(.gray)
                Text(value)
                    .foregroundColor(.black)
                Image(systemName: "chevron.down")
                    .foregroundColor(.gray)
                    .font(.caption)
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(Color(UIColor.systemGray6))
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
