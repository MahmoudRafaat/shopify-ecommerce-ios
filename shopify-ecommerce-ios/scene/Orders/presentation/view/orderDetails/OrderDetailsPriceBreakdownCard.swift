//
//  OrderDetailsPriceBreakdownCard.swift
//  shopify-ecommerce-ios
//
//  Created by Mahmoud Raafat Mustafa on 06/07/2026.
//
import SwiftUI


struct OrderDetailsPriceBreakdownCard: View {
    let order: OrderDisplayModel
    
    var body: some View {
        VStack(spacing: 8) {
            OrderDetailsPriceRow(label: "Subtotal", value: order.formattedSubtotal)
            
            if let discount = order.formattedDiscount {
                OrderDetailsPriceRow(label: "Discount", value: "-\(discount)", isDiscount: true)
            }
            
            OrderDetailsPriceRow(label: "Tax", value: order.formattedTax)
            
            Divider()
                .padding(.vertical, 4)
            
            OrderDetailsPriceRow(label: "Total", value: order.formattedTotal, isTotal: true)
        }
        .padding(20)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
    }
}



