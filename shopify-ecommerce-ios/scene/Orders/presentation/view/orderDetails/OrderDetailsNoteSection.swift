//
//  OrderDetailsNoteSection.swift
//  shopify-ecommerce-ios
//
//  Created by Mahmoud Raafat Mustafa on 06/07/2026.
//

import SwiftUI

struct OrderDetailsNoteSection: View {
    let note: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "info.circle.fill")
                .font(.title3)
                .foregroundStyle(AppColor.brandPrimary)
            
            Text(note)
                .font(.subheadline)
                .foregroundStyle(.primary)
            
            Spacer()
        }
        .padding(16)
        .background(AppColor.brandPrimary.opacity(0.08))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(AppColor.brandPrimary.opacity(0.2), lineWidth: 1)
        )
    }
}

