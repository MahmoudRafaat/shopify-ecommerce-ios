import SwiftUI

struct CheckoutProductItemView: View {
    @Environment(CheckoutViewModel.self) var viewModel
    let item: DraftLineItemRequest
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            // Product Image
            Image(.checkout)
                .resizable()
                .scaledToFill()
                .frame(width: 125, height: 155)
                .cornerRadius(8)
                .clipped()
            
            // Product Details
            VStack(alignment: .leading, spacing: 8) {
                Text("Women's Casual Wear")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                
                Text("Checked Single-Breasted Blazer")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .fixedSize(horizontal: false, vertical: true)
                
                HStack(spacing: 12) {
                    Menu {
                        // Dummy sizes mapped to variant IDs for demonstration
                        let sizes = [("38", 101), ("40", 102), ("42", 103)]
                        ForEach(sizes, id: \.1) { size, variantId in
                            Button(size) {
                                Task {
                                    await viewModel.updateSize(from: item.variantId, toNewVariantId: variantId)
                                }
                            }
                        }
                    } label: {
                        CheckoutDropdownView(
                            title: "Size",
                            value: "42",
                            action: {}
                        )
                    }
                    
                    Menu {
                        ForEach(1...10, id: \.self) { qty in
                            Button("\(qty)") {
                                Task {
                                    await viewModel.updateQuantity(for: item.variantId, to: qty)
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
    CheckoutProductItemView(item: DraftLineItemRequest(variantId: 101, quantity: 1))
}
