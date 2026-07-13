import SwiftUI

struct CheckoutNavigationBar: View {
    var title: String = "Shopping Cart"
    
    var body: some View {
        HStack {
            Spacer()
            
            Text(title)
                .font(.headline)
                .fontWeight(.bold)
            
            Spacer()
        }
        .padding(.horizontal)
        .padding(.top, 12)
        .padding(.bottom, 32)
    }
}

#Preview {
    CheckoutNavigationBar()
}
