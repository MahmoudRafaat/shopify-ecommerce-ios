//
//  OrderRowView.swift
//  shopify-ecommerce-ios
//
//  Created by Mahmoud Raafat Mustafa on 06/07/2026.
//

import SwiftUI

struct OrderRowView: View {
    @Environment(CurrencyService.self) private var currencyService
    let order: OrderDisplayModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(order.orderName)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(.primary)
                    
                    Text(order.formattedDate)
                        .font(.system(size: 13))
                        .foregroundStyle(AppColor.textSecondary)
                }
                
                Spacer()
                
                Text(order.status.label)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundStyle(AppColor.backgroundPrimary)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 4)
                    .background(order.status.color)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            
            HStack {
                Text("\(order.lineItems.count) \(order.lineItems.count == 1 ? "item" : "items")")
                    .font(.system(size: 14))
                    .foregroundStyle(AppColor.textSecondary)
                
                Spacer()
                
                Text(PriceFormatter.format(amountString: order.rawTotal, currencyService: currencyService))
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(.appBlue)
            }
            
            HStack {
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.system(size: 12))
                    .foregroundStyle(AppColor.textSecondary)
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
    }
}
