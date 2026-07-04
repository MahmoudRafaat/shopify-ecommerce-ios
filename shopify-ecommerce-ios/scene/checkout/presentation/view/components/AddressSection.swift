//
//  AdressSection.swift
//  shopify-ecommerce-ios
//
//  Created by Ehab Salah on 04/07/2026.
//

import SwiftUI

struct AddressSection: View {
    @Environment(CheckoutViewModel.self) var viewModel
    var body: some View {
        HStack(spacing: 12) {
            if let address = viewModel.currentAddress,
               let address1 = address.address1,
               let city = address.city,
               let country = address.country {
                AddressView(
                    address: "\(address1), \(city), \(country)",
                    contact: address.phone ?? "No phone provided",
                    editAction: { viewModel.isAddressSheetPresented = true }
                )
            } else {
                AddressView(
                    address: "No Address Provided",
                    contact: "Tap '+' to add an address",
                    editAction: { viewModel.isAddressSheetPresented = true }
                )
            }
            AddressAddButtonView(action: {
                viewModel.isAddressSheetPresented = true
            })
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
    }
}

#Preview {
    AddressSection()
}
