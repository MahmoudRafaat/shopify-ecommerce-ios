//
//  CurrencyPickerView.swift
//  shopify-ecommerce-ios
//
//  Created by albaraa alsayed on 22/01/1448 AH.
//

import SwiftUI

struct CurrencyPickerView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(CurrencyService.self) private var currencyService
    
    var body: some View {
        List {
            if currencyService.supportedCurrencies.isEmpty {
                Text("Loading currencies...")
                    .foregroundColor(.gray)
            } else {
                ForEach(currencyService.supportedCurrencies, id: \.self) { code in
                Button {
                    currencyService.selectedCurrency = code
                    dismiss()
                } label: {
                    HStack {
                        Text(code)
                            .foregroundColor(.primary)
                        Spacer()
                        if currencyService.selectedCurrency == code {
                            Image(systemName: "checkmark")
                                .foregroundColor(.appPrimary)
                        }
                    }
                }
            }
        }
        }
        .navigationTitle("Select Currency")
        .navigationBarTitleDisplayMode(.inline)
    }
}
