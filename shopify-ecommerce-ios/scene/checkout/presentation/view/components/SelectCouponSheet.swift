//
//  SelectCouponSheet.swift
//  shopify-ecommerce-ios
//
//  Created by Ehab Salah on 05/07/2026.
//

import SwiftUI

struct SelectCouponSheet: View {
    @Environment(CheckoutViewModel.self) var viewModel
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.activeCoupons.keys.sorted(), id: \.self) { code in
                    if let rule = viewModel.activeCoupons[code] {
                        Button(action: {
                            viewModel.selectedCouponCode = code
                            viewModel.selectedCoupon = rule
                            viewModel.isCouponSheetPresented = false
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(code)
                                        .font(.headline)
                                        .foregroundColor(.black)
                                    
                                    if rule.valueType == "percentage" {
                                        Text("\(rule.value.replacingOccurrences(of: "-", with: ""))% OFF")
                                            .font(.subheadline)
                                            .foregroundColor(.green)
                                    } else {
                                        Text("$\(rule.value.replacingOccurrences(of: "-", with: "")) OFF")
                                            .font(.subheadline)
                                            .foregroundColor(.green)
                                    }
                                }
                                
                                Spacer()
                                
                                if viewModel.selectedCouponCode == code {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(Color("appPrimary"))
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Select Coupon")
            .navigationBarItems(trailing: Button("Cancel") {
                viewModel.isCouponSheetPresented = false
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}
