//
//  OrderDetailsView.swift
//  shopify-ecommerce-ios
//
//  Created by Mahmoud Raafat Mustafa on 06/07/2026.
//

import SwiftUI

struct OrderDetailsView: View {
    let order: OrderDisplayModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                OrderDetailsHeaderCard(order: order)
                OrderDetailsLineItemsSection(lineItems: order.lineItems)
                OrderDetailsPriceBreakdownCard(order: order)
                
                if let note = order.note, !note.isEmpty {
                    OrderDetailsNoteSection(note: note)
                }
                
                if let address = order.shippingAddress, address.hasValidAddress {
                    OrderDetailsAddressSection(title: "Shipping Address", address: address, icon: "truck.box")
                }
                
                if let address = order.billingAddress, address.hasValidAddress {
                    OrderDetailsAddressSection(title: "Billing Address", address: address, icon: "creditcard")
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 16)
        }
        .background(Color(white: 0.98))
        .navigationTitle("Order Details")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    dismiss()
                } label: {
                    HStack(spacing: 4) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 16, weight: .medium))
                        Text("Orders")
                            .font(.system(size: 16, weight: .medium))
                    }
                    .foregroundStyle(.appPrimary)
                }
            }
        }
    }
}


