import SwiftUI

struct CheckoutIconButton: View {
    var iconName: String
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(systemName: iconName)
                .font(.title3)
                .foregroundColor(.black)
        }
    }
}

#Preview {
    HStack {
        CheckoutIconButton(iconName: "chevron.left", action: {})
        CheckoutIconButton(iconName: "heart", action: {})
    }
}
