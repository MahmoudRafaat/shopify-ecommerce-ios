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
                HStack(alignment: .top) {
                    Text("Women's Casual Wear")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                    
                    Spacer()
                    
                    Button {
                        Task {
                            await viewModel.removeLineItem(variantId: item.variantId)
                        }
                    } label: {
                        Image(systemName: "trash")
                            .font(.system(size: 16))
                            .foregroundColor(.red)
                    }
                    .buttonStyle(.plain)
                }
                
                Text("Checked Single-Breasted Blazer")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .fixedSize(horizontal: false, vertical: true)
                
                HStack(spacing: 12) {
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
