//
//  ProductCartView.swift
//  shopify-ecommerce-ios
//
//  Created by albaraa alsayed on 18/01/1448 AH.
//

import SwiftUI

struct ProductCartView: View {
    
    let productCardState: ProductCardState
    let action : (ProductCardState) -> Void
    private var totalPrice: Float {
        productCardState.price * Float(productCardState.numberOfItems)
    }
    
    var body: some View {
        VStack(spacing: 18) {
            HStack(alignment: .top, spacing: 14) {
                CachedImageLoader(
                    urlString: productCardState.image,
                    width: 110,
                    height: 110
                )
                .clipShape(RoundedRectangle(cornerRadius: 10))
                
                VStack(alignment: .leading, spacing: 12) {
                    
                    Text(productCardState.name)
                        .font(.headline)
                        .fontWeight(.semibold)
                        .lineLimit(2)
                    
                    HStack(alignment: .center, spacing: 10) {
                        
                        Text("Variations:")
                            .font(.subheadline)
                            .fontWeight(.medium)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 8) {
                                ForEach(productCardState.colors, id: \.self) { color in
                                    VariationChip(title: color)
                                }
                            }
                        }
                    }
                    
                    HStack(spacing: 5) {
                        Text(String(format: "%.1f", productCardState.rating))
                            .font(.subheadline)
                        StarsView(rating: productCardState.rating, starsSize: 13)
                    }
                    
                    HStack(alignment: .center, spacing: 12) {
                        
                        Text("$\(productCardState.price, specifier: "%.2f")")
                            .font(.system(size: 15, weight: .bold))
                            .padding(.horizontal, 14)
                            .padding(.vertical, 8)
                            .overlay {
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(.gray.opacity(0.3))
                            }
                        
                        VStack(alignment: .leading, spacing: 3) {
                            
                            Text("upto \(Int(productCardState.discount))% off")
                                .font(.system(size: 10, weight: .medium))
                                .foregroundColor(.red)
                            
                            Text("$\(productCardState.oldPrice, specifier: "%.2f")")
                                .font(.system(size: 11, weight: .medium))
                                .foregroundStyle(.secondary)
                                .strikethrough()
                        }
                    }
                }
                Spacer()
            }
            
            Divider()
            
            HStack {
                Text("Total Order (\(productCardState.numberOfItems))")
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                Spacer()
                
                Text("$\(totalPrice, specifier: "%.2f")")
                    .font(.headline)
                    .fontWeight(.bold)
            }
        }
        .padding(14)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: .black.opacity(0.08), radius: 10)
        .onTapGesture {
            action(productCardState)
        }
    }
}

#Preview {
    let productCart = ProductCardState(
        image: "",
        name: "Women's Casual Wear",
        colors: ["Black", "Red"],
        price: 34.0,
        rating: 4.8,
        discount: 33,
        oldPrice: 64.0,
        numberOfItems: 1
    )
    ProductCartView(
        productCardState: productCart,
        action: { productCart in
            print(productCart)
        }
    )
}
