//
//  OrderDetailsPriceRow.swift
//  shopify-ecommerce-ios
//
//  Created by Mahmoud Raafat Mustafa on 06/07/2026.
//
import SwiftUI


struct OrderDetailsPriceRow: View {
    let label: String
    let value: String
    var isDiscount: Bool = false
    var isTotal: Bool = false
    
    var body: some View {
        HStack {
            Text(label)
                .font(isTotal ? .headline : .subheadline)
                .foregroundStyle(isTotal ? .primary : .secondary)
            
            Spacer()
            
            Text(value)
                .font(isTotal ? .title3.bold() : .subheadline)
                .foregroundStyle(isDiscount ? .red : (isTotal ? .appBlue : .primary))
        }
    }
}
