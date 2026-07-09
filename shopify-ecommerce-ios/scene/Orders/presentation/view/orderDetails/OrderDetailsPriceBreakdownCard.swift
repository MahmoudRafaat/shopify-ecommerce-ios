//
//  OrderDetailsPriceBreakdownCard.swift
//  shopify-ecommerce-ios
//
//  Created by Mahmoud Raafat Mustafa on 06/07/2026.
//
import SwiftUI


struct OrderDetailsPriceBreakdownCard: View {
    let order: OrderDisplayModel
    @Environment(CurrencyService.self) private var currencyService
    
    var body: some View {
        VStack(spacing: 8) {
            OrderDetailsPriceRow(label: "Subtotal", value: PriceFormatter.format(amountString: order.rawSubtotal, currencyService: currencyService))
            
            if let rawDiscount = order.rawDiscount {
                OrderDetailsPriceRow(label: "Discount", value: "-\(PriceFormatter.format(amountString: rawDiscount, currencyService: currencyService))", isDiscount: true)
            }
            
            OrderDetailsPriceRow(label: "Tax", value: PriceFormatter.format(amountString: order.rawTax, currencyService: currencyService))
            
            Divider()
                .padding(.vertical, 4)
            
            OrderDetailsPriceRow(label: "Total", value: PriceFormatter.format(amountString: order.rawTotal, currencyService: currencyService), isTotal: true)
        }
        .padding(20)
        .background(AppColor.backgroundPrimary)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
    }
}



