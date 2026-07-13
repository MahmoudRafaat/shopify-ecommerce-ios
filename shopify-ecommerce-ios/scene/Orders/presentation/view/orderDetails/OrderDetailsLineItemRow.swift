//
//  OrderDetailsLineItemRow.swift
//  shopify-ecommerce-ios
//
//  Created by Mahmoud Raafat Mustafa on 06/07/2026.
//

import SwiftUI
struct OrderDetailsLineItemRow: View {
    @Environment(CurrencyService.self) private var currencyService
    let item: OrderLineItemDisplay
    
    var body: some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                Text(item.displayName)
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                if let sku = item.sku, !sku.isEmpty {
                    Text("SKU: \(sku)")
                        .font(.caption)
                        .foregroundStyle(AppColor.textSecondary)
                }
            }
            
            Spacer()
            
            HStack(spacing: 8) {
                Text("×\(item.quantity)")
                    .font(.caption)
                    .foregroundStyle(AppColor.textSecondary)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 2)
                    .background(AppColor.textSecondary.opacity(0.15))
                    .clipShape(RoundedRectangle(cornerRadius: 4))
                
                Text(PriceFormatter.format(amountString: item.price, currencyService: currencyService))
                    .font(.subheadline)
                    .fontWeight(.semibold)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
    }
}

