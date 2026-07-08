//
//  LoadingView.swift
//  shopify-ecommerce-ios
//
//  Created by Ehab Salah on 29/06/2026.
//

import SwiftUI

struct LoadingView: View {
    
    var body: some View {
        ZStack {
            AppColor.textPrimary.opacity(0.15)
                .ignoresSafeArea()
            
            VStack(spacing: 16) {
                ProgressView()
                    .progressViewStyle(
                        CircularProgressViewStyle(tint: .appPrimary)
                    )
                    .scaleEffect(1.3)
                
            }
            .padding(24)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(AppColor.backgroundPrimary)
                    .shadow(color: Color.black.opacity(0.08), radius: 10, x: 0, y: 4)
            )
        }
    }
}

#Preview {
    LoadingView()
}
