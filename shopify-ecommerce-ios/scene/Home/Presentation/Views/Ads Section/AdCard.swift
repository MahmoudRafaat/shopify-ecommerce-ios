//
//  AdCard.swift
//  shopify-ecommerce-ios
//
//  Created by albaraa alsayed on 12/01/1448 AH.
//

import SwiftUI

struct AdCard: View {

    let title: String
    let category: String
    let colors: String
    var action: () -> Void
    
    var body: some View {
        ZStack(alignment: .leading) {
            Image(.ad)
                .resizable()
                .scaledToFill()
            
            VStack(alignment: .leading, spacing: 8) {
                Text(title)
                    .font(.system(size: 24, weight: .bold))
                    .foregroundStyle(Color.white)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Now in (\(category))")
                        .font(.system(size: 12, weight: .light))
                        .foregroundStyle(Color.white)
                    
                    Text(colors)
                        .font(.system(size: 12, weight: .light))
                        .foregroundStyle(Color.white)
                }
                TrailingIconOutlinedButton(title: "Shop now", action: action)
            }
            .padding(14)
        }
        .frame(height: 189)
        .clipShape(RoundedRectangle(cornerRadius: 15))
        .padding(16)
    }
}

#Preview {
    AdCard(title: "50-40% OFF", category: "product", colors: "All colours") {}
}
