import SwiftUI

struct CheckoutNavigationBar: View {
    var title: String = "Shopping Bag"
    var onBack: (() -> Void)? = nil
    var onWishlist: (() -> Void)? = nil
    
    var body: some View {
        HStack {
            CheckoutIconButton(iconName: "chevron.left") {
                onBack?()
            }
            
            Spacer()
            
            Text(title)
                .font(.headline)
                .fontWeight(.bold)
            
            Spacer()
            
            CheckoutIconButton(iconName: "heart") {
                onWishlist?()
            }
        }
        .padding(.horizontal)
        .padding(.top, 12)
        .padding(.bottom, 32)
    }
}

#Preview {
    CheckoutNavigationBar()
}
