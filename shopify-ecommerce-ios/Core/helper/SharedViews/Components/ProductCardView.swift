//
//  ProductCard.swift
//  shopify-ecommerce-ios
//
//  Created by albaraa alsayed on 13/01/1448 AH.
//

import SwiftUI

struct ProductCardView: View {
    let product: Product
    var onTap: () -> Void
    var body: some View {
        VStack(spacing: 8) {
            
            CachedImageLoader(
                urlString: product.image,
                width: nil,
                height: 124
            )
            .frame(maxWidth: .infinity)
            .cornerRadius(10)
            
            
            VStack(alignment: .leading, spacing: 6) {
                Text(product.name)
                    .font(.system(size: 12, weight: .semibold))
                    .lineLimit(1)
                
                Text(product.description)
                    .font(.system(size: 10))
                    .foregroundColor(.gray)
                    .lineLimit(2)
                
                Text(product.price, format: .currency(code: "USD"))
                    .font(.system(size: 12, weight: .bold))
                HStack(spacing: 4) {
                    Text(product.oldPrice, format: .currency(code: "USD"))
                        .font(.system(size: 10, weight: .regular))
                        .strikethrough()
                        .foregroundStyle(Color.gray)
                    Text("\(product.discount)%Off")
                        .font(.system(size: 10, weight: .regular))
                        .foregroundStyle(Color.appLightRed)
                }
                
                HStack{
                    StarsView(rating: product.stars, starsSize: 10)
                    Text("(\(product.reviewers))")
                        .font(.system(size: 10, weight: .light))
                        .foregroundColor(.gray)
                        .padding(.leading, 2)
                }
            }
            .padding(8)
        }
        .frame(width: 170, height: 250)
        .background(Color.white)
        .cornerRadius(10)
        .shadow(color: .gray.opacity(0.15), radius: 8, x: 0, y: 4)
        .onTapGesture {
            onTap()
        }
    }
    
}

#Preview {
    ProductCardView(product: Product(id: 1,
                                     image: "watch",
                                     name: "Women Printed Kurta",
                                     description: "Neque porro quisquam est qui dolorem ipsum quia",
                                     price: 1500.0,
                                     isAvailabe: true,
                                     productType: "accessories"),
                    onTap: {})
}
