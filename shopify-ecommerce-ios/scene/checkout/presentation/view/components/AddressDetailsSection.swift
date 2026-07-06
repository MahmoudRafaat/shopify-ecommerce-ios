//
//  AddressDetailsSection.swift
//  shopify-ecommerce-ios
//
//  Created by Ehab Salah on 04/07/2026.
//


import SwiftUI

struct AddressDetailsSection: View {
    @Binding var address1: String
    @Binding var city: String
    @Binding var country: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Address Details")
                .font(.headline)
                .foregroundColor(.gray)
                .padding(.horizontal, 28)
            
            CustomTextField(placeholder: "Address", type: .address, hasError: false, text: $address1)
            CustomTextField(placeholder: "City", type: .city, hasError: false, text: $city)
            CustomTextField(placeholder: "Country", type: .country, hasError: false, text: $country)
        }
        .padding(.top, 16)
    }
}
