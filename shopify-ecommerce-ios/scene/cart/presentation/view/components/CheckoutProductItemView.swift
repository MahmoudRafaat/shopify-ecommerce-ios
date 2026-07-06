import SwiftUI
import Kingfisher
struct CheckoutProductItemView: View {
    @Environment(CartViewModel.self) var viewModel
    let item: OrderItemUIModel
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            // Product Image
            CachedImageLoader(
                urlString: item.imageUrl ?? "",
                width: 125,
                height: 155
            )
            .cornerRadius(8)
            
            // Product Details
            VStack(alignment: .leading, spacing: 8) {
                HStack(alignment: .top) {
                    Text(item.title)
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                        .lineLimit(2)
                    
                    Spacer()
                    
                    Button {
                        Task {
                            await viewModel.removeLineItem(variantId: item.id)
                        }
                    } label: {
                        Image(systemName: "trash")
                            .font(.system(size: 16))
                            .foregroundColor(.red)
                    }
                    .buttonStyle(.plain)
                }
                
                Text(item.variantTitle)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .fixedSize(horizontal: false, vertical: true)
                
                Text("$\(item.price)")
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                
                HStack(spacing: 12) {
                    Menu {
                        ForEach(1...10, id: \.self) { qty in
                            Button("\(qty)") {
                                Task {
                                    await viewModel.updateQuantity(for: item.id, to: qty)
                                }
                            }
                        }
                    } label: {
                        CheckoutDropdownView(
                            title: "Qty",
                            value: "\(item.quantity)",
                            action: {}
                        )
                    }
                }
                .font(.footnote)
                
                HStack(spacing: 4) {
                    Text("Delivery by")
                        .font(.footnote)
                        .foregroundColor(.gray)
                    Text("10 May 2XXX")
                        .font(.footnote)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                }
                .padding(.top, 4)
            }
            
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
    }
}

#Preview {
//    CheckoutProductItemView(item: OrderItemUIModel(id: 101, title: "Mock", variantTitle: "Mock Variant", price: "10.0", quantity: 1, imageUrl: nil))
}
