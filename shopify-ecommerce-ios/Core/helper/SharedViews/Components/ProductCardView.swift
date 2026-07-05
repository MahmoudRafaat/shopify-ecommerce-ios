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
            
            
            VStack(alignment: .leading, spacing: 4) {
                Text(product.name)
                    .font(.system(size: 12, weight: .semibold))
                    .lineLimit(1)
                
                HStack(spacing: 4) {
                    Text(product.vendor)
                        .foregroundStyle(Color.white)
                        .padding(.vertical, 2)
                        .padding(.horizontal, 6)
                        .background(.appBlue)
                        .cornerRadius(4)
                    Text("·")
                    Text(product.productType)
                        .foregroundStyle(Color.gray)
                        .padding(.vertical, 2)
                        .padding(.horizontal, 6)
                        .background(.gray.opacity(0.15))
                        .cornerRadius(4)
                }
                .font(.system(size: 10))
                .foregroundColor(.secondary)
                .lineLimit(1)
                
                Text(product.description)
                    .font(.system(size: 10))
                    .foregroundColor(.gray)
                    .lineLimit(1)
                Spacer()
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
                starsView(productStars: product.stars)
            }
            .padding(8)
            
        }
        .frame(width: 170, height: 260)
        .background(Color.white)
        .cornerRadius(10)
        .shadow(color: .gray.opacity(0.15), radius: 8, x: 0, y: 4)
        .onTapGesture {
            onTap()
        }
    }
    
    private func starsView(productStars: Float) -> some View {
        return HStack(spacing: 2) {
            ForEach(0..<5, id: \.self) { index in
                let floatIndex = Float(index)
                
                if product.stars - floatIndex >= 1 {
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                } else if product.stars - floatIndex >= 0.5 {
                    Image(systemName: "star.leadinghalf.filled")
                        .foregroundColor(.yellow)
                } else {
                    Image(systemName: "star")
                        .foregroundColor(.gray.opacity(0.5))
                }
            }
            .font(.system(size: 10))
            
            Text("(\(product.reviewers))")
                .font(.system(size: 10, weight: .light))
                .foregroundColor(.gray)
                .padding(.leading, 2)
        }
    }
}

#Preview {
    ProductCardView(product: Product(id: 1,
                                     image: "watch",
                                     name: "Women Printed Kurta",
                                     description: "Neque porro quisquam est qui dolorem ipsum quia",
                                     vendor: "NIKE",
                                     price: 1500.0,
                                     isAvailabe: true,
                                     productType: "Accessories"),
                    onTap: {})
}
