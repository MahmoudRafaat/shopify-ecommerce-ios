//
//  SelectCouponSheet.swift
//  shopify-ecommerce-ios
//
//  Created by Ehab Salah on 05/07/2026.
//

import SwiftUI

struct SelectCouponSheet: View {
    @Environment(CartViewModel.self) var viewModel
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.uiState.activeCoupons.keys.sorted(), id: \.self) { code in
                    if let rule = viewModel.uiState.activeCoupons[code] {
                        Button(action: {
                            viewModel.uiState.selectedCouponCode = code
                            viewModel.uiState.selectedCoupon = rule
                            viewModel.uiState.isCouponSheetPresented = false
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(code)
                                        .font(.headline)
                                        .foregroundColor(AppColor.textPrimary)
                                    
                                    if rule.valueType == "percentage" {
                                        Text("\(rule.value.replacingOccurrences(of: "-", with: ""))% OFF")
                                            .font(.subheadline)
                                            .foregroundColor(AppColor.successDefault)
                                    } else {
                                        Text("$\(rule.value.replacingOccurrences(of: "-", with: "")) OFF")
                                            .font(.subheadline)
                                            .foregroundColor(AppColor.successDefault)
                                    }
                                }
                                
                                Spacer()
                                
                                if viewModel.uiState.selectedCouponCode == code {
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
                viewModel.uiState.isCouponSheetPresented = false
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}
