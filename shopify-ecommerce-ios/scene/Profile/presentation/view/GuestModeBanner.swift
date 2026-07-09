//
//  GuestModeBanner.swift
//  shopify-ecommerce-ios
//
//  Created by Mahmoud Raafat Mustafa on 04/07/2026.
//

import SwiftUI

struct GuestModeBanner: View {
    let brandColor: Color
    let onSignIn: () -> Void
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "person.crop.circle.badge.exclamationmark")
                .font(.system(size: 48))
                .foregroundColor(AppColor.warningDefault)
            
            Text("Guest Mode")
                .font(.title2)
                .fontWeight(.bold)
            
            Text("Sign in to view and edit your profile information")
                .font(.subheadline)
                .foregroundColor(AppColor.textSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
            
            Button {
                onSignIn()  
            } label: {
                Text("Sign In")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(AppColor.backgroundPrimary)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(brandColor)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .padding(.horizontal, 32)
            .padding(.top, 8)
        }
        .padding(.vertical, 24)
        .background(AppColor.textSecondary.opacity(0.05))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .padding(.horizontal, 16)
    }
}
