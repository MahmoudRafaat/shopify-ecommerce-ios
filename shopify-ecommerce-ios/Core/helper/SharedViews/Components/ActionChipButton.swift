//
//  ActionChipButton.swift
//  shopify-ecommerce-ios
//
//  Created by Yomna on 29/06/2026.
//

import SwiftUI

struct ActionChipButton: View {
    let title : String
    let systemImage: String
    let action : () -> Void
    
    var body: some View {
        Button(action: action){
            HStack(spacing: 8){
                Text(title).font(.callout)
                Image(systemImage)
            }
        }
        .foregroundStyle(AppColor.textPrimary)
        .padding(.horizontal,16)
        .frame(height: 32)
        .background(AppColor.backgroundPrimary)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .shadow(color: .black.opacity(0.05),
                radius: 4,
                y: 2)
        
    }
}

#Preview {
    ActionChipButton(title: "Filter", systemImage: "filter-icon", action: {print("filter")})
}
