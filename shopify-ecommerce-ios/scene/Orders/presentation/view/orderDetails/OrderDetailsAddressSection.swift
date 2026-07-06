//
//  OrderDetailsAddressSection.swift
//  shopify-ecommerce-ios
//
//  Created by Mahmoud Raafat Mustafa on 06/07/2026.
//

import SwiftUI
struct OrderDetailsAddressSection: View {
    let title: String
    let address: OrderAddressDisplay
    let icon: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .foregroundStyle(.gray)
                Text(title)
                    .font(.headline)
            }
            
            if !address.fullName.isEmpty {
                Text(address.fullName)
                    .font(.subheadline)
            }
            
            Text(address.formattedAddress)
                .font(.subheadline)
                .foregroundStyle(.secondary)
            
            if let phone = address.phone, !phone.isEmpty {
                HStack(spacing: 8) {
                    Image(systemName: "phone.fill")
                        .font(.caption)
                        .foregroundStyle(.gray)
                    Text(phone)
                        .font(.subheadline)
                }
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
    }
}
