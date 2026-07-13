//
//  PaymentRow.swift
//  shopify-ecommerce-ios
//
//  Created by Mahmoud Raafat Mustafa on 04/07/2026.
//

import SwiftUI

struct PaymentRow: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .font(.subheadline)
                .foregroundColor(AppColor.textSecondary)
                .frame(width: 20)
            
            Text(text)
                .font(.subheadline)
        }
    }
}
