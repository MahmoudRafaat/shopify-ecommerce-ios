//
//  StarsView.swift
//  shopify-ecommerce-ios
//
//  Created by albaraa alsayed on 18/01/1448 AH.
//

import SwiftUI

struct StarsView: View {
    let rating : Float
    let starsSize : CGFloat
    var body: some View {
        HStack(spacing: 2) {
            ForEach(0..<5, id: \.self) { index in
                let floatIndex = Float(index)
                
                if rating - floatIndex >= 1 {
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                } else if rating - floatIndex >= 0.5 {
                    Image(systemName: "star.leadinghalf.filled")
                        .foregroundColor(AppColor.textSecondary.opacity(0.5))
                } else {
                    Image(systemName: "star")
                        .foregroundColor(AppColor.textSecondary.opacity(0.5))
                }
            }
            .font(.system(size: starsSize))
        }
    }
}

#Preview {
    StarsView(rating: 4.8, starsSize: 14)
}
