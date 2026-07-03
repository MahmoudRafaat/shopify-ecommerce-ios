//
//  VariationChip.swift
//  shopify-ecommerce-ios
//
//  Created by albaraa alsayed on 18/01/1448 AH.
//

import SwiftUI

struct VariationChip: View {
    
    let title: String
    
    var body: some View {
        Text(title)
            .font(.footnote)
            .fontWeight(.medium)
            .padding(.horizontal, 14) 
            .padding(.vertical, 6)
            .overlay {
                RoundedRectangle(cornerRadius: 6)
                    .stroke(.gray.opacity(0.4), lineWidth: 1)
            }
    }
}

#Preview {
    VariationChip(title: "Color")
}
