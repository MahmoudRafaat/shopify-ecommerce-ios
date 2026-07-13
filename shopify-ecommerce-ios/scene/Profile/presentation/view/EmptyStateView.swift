//
//  EmptyStateView.swift
//  shopify-ecommerce-ios
//
//  Created by Mahmoud Raafat Mustafa on 04/07/2026.
//


import SwiftUI
struct EmptyStateView: View {
    let icon: String
    let title: String
    let message: String
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 36))
                .foregroundColor(AppColor.textSecondary)
            
            Text(title)
                .font(.headline)
                .foregroundColor(AppColor.textSecondary)
            
            Text(message)
                .font(.subheadline)
                .foregroundColor(AppColor.textSecondary.opacity(0.7))
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
    }
}
