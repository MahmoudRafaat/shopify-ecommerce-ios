//
//  OrderSkeletonRow.swift
//  shopify-ecommerce-ios
//
//  Created by Mahmoud Raafat Mustafa on 06/07/2026.
//



import SwiftUI

struct OrderSkeletonRow: View {
    @State private var isAnimating = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(AppColor.textSecondary.opacity(0.3))
                        .frame(width: 120, height: 18)
                    
                    RoundedRectangle(cornerRadius: 4)
                        .fill(AppColor.textSecondary.opacity(0.2))
                        .frame(width: 80, height: 14)
                }
                
                Spacer()
                
                RoundedRectangle(cornerRadius: 12)
                    .fill(AppColor.textSecondary.opacity(0.3))
                    .frame(width: 80, height: 24)
            }
            
            HStack {
                RoundedRectangle(cornerRadius: 4)
                    .fill(AppColor.textSecondary.opacity(0.2))
                    .frame(width: 60, height: 14)
                
                Spacer()
                
                RoundedRectangle(cornerRadius: 4)
                    .fill(AppColor.textSecondary.opacity(0.3))
                    .frame(width: 80, height: 18)
            }
        }
        .padding(16)
        .background(AppColor.backgroundPrimary)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(
            color: .black.opacity(0.05),
            radius: 8,
            x: 0,
            y: 2
        )
        .opacity(isAnimating ? 0.5 : 1.0)
        .animation(
            Animation.easeInOut(duration: 1.0)
                .repeatForever(autoreverses: true),
            value: isAnimating
        )
        .onAppear {
            isAnimating = true
        }
    }
}
