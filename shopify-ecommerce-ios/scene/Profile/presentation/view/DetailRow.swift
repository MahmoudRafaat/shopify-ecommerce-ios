//
//  DetailRow.swift
//  shopify-ecommerce-ios
//
//  Created by Mahmoud Raafat Mustafa on 04/07/2026.
//

import SwiftUI

struct DetailRow: View {
    let label: String
    let value: String
    
    var body: some View {
        HStack(alignment: .top) {
            Text(label + ":")
                .font(.subheadline)
                .foregroundColor(AppColor.textSecondary)
                .frame(width: 70, alignment: .leading)
            
            Text(value.isEmpty ? "Not set" : value)
                .font(.subheadline)
                .foregroundColor(value.isEmpty ? AppColor.textSecondary.opacity(0.7) : .primary)
        }
    }
}
