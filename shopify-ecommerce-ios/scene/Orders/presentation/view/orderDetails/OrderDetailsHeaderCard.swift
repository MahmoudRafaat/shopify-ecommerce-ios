//
//  OrderDetailsHeaderCard.swift
//  shopify-ecommerce-ios
//
//  Created by Mahmoud Raafat Mustafa on 06/07/2026.
//

import SwiftUI

struct OrderDetailsHeaderCard: View {
    let order: OrderDisplayModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(order.orderName)
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text(order.formattedDate)
                        .font(.subheadline)
                        .foregroundStyle(AppColor.textSecondary)
                }
                
                Spacer()
                
                Text(order.status.label)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(AppColor.backgroundPrimary)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 6)
                    .background(order.status.color)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
            }
        }
        .padding(20)
        .background(AppColor.backgroundPrimary)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
    }
}

struct OrderDetailsLineItemsSection: View {
    let lineItems: [OrderLineItemDisplay]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Items")
                .font(.headline)
                .padding(.horizontal, 4)
            
            VStack(spacing: 0) {
                ForEach(lineItems) { item in
                    OrderDetailsLineItemRow(item: item)
                    
                    if item.id != lineItems.last?.id {
                        Divider()
                            .padding(.horizontal, 12)
                    }
                }
            }
            .background(AppColor.backgroundPrimary)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
        }
    }
}
