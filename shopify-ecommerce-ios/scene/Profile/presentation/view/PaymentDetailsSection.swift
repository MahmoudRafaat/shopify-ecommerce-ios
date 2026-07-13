//
//  PaymentDetailsSection.swift
//  shopify-ecommerce-ios
//
//  Created by Mahmoud Raafat Mustafa on 04/07/2026.
//

import SwiftUI

struct PaymentDetailsSection: View {
    let uiState: ProfileUIState
    @Binding var isEditing: Bool
 
    
    @Binding var tempCardholderName: String
    @Binding var tempCardNumber: String
    @Binding var tempExpiryMonth: String
    @Binding var tempExpiryYear: String
    @Binding var tempCvv: String
    let brandColor: Color
    let onSave: () -> Void

    private var isPaymentValid: Bool {
        !tempCardholderName.isEmpty &&
        tempCardNumber.count >= 4 &&
        !tempExpiryMonth.isEmpty &&
        !tempExpiryYear.isEmpty &&
        !tempCvv.isEmpty
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Payment Details")
                    .font(.title3).fontWeight(.bold)
                
                Spacer()
                
                if uiState.isLoggedIn && !isEditing {
                    Button(uiState.hasPaymentDetails ? "Edit" : "Add") {
                        tempCardholderName = uiState.cardholderName
                        tempCardNumber = uiState.cardNumber
                        tempExpiryMonth = uiState.expiryMonth
                        tempExpiryYear = uiState.expiryYear
                        tempCvv = uiState.cvv
                        isEditing = true
                    }
                    .font(.system(size: 14))
                    .foregroundStyle(AppColor.brandPrimary)
                }
            }
            .padding(.horizontal, 28)
            
            if isEditing {
                Group {
                    CustomTextField(
                        placeholder: "Cardholder Name",
                        type: .name,
                        hasError: false,
                        text: $tempCardholderName
                    )
                    .disabled(uiState.isSavingPayment || !uiState.isLoggedIn)
                    .opacity(uiState.isLoggedIn ? 1 : 0.6)
                    
                    CustomTextField(
                        placeholder: "Card Number",
                        type: .number,
                        hasError: false,
                        text: $tempCardNumber
                    )
                    .disabled(uiState.isSavingPayment || !uiState.isLoggedIn)
                    .opacity(uiState.isLoggedIn ? 1 : 0.6)
                    
                    HStack(spacing: 12) {
                        CustomTextField(
                            placeholder: "MM",
                            type: .number,
                            hasError: false,
                            text: $tempExpiryMonth
                        )
                        .disabled(uiState.isSavingPayment || !uiState.isLoggedIn)
                        .opacity(uiState.isLoggedIn ? 1 : 0.6)
                        .frame(maxWidth: .infinity)
                        
                        CustomTextField(
                            placeholder: "YY",
                            type: .number,
                            hasError: false,
                            text: $tempExpiryYear
                        )
                        .disabled(uiState.isSavingPayment || !uiState.isLoggedIn)
                        .opacity(uiState.isLoggedIn ? 1 : 0.6)
                        .frame(maxWidth: .infinity)
                    }
                    .padding(.horizontal, 28)
                    
                    CustomTextField(
                        placeholder: "CVV",
                        type: .number,
                        hasError: false,
                        text: $tempCvv
                    )
                    .disabled(uiState.isSavingPayment || !uiState.isLoggedIn)
                    .opacity(uiState.isLoggedIn ? 1 : 0.6)
                }
                
                HStack(spacing: 12) {
                    Button("Cancel") {
                        isEditing = false
                    }
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(AppColor.textSecondary)
                    .frame(maxWidth: .infinity)
                    .frame(height: 44)
                    
                    Button {
                        onSave()
                    } label: {
                        if uiState.isSavingPayment {
                            ProgressView()
                                .tint(AppColor.backgroundPrimary)
                        } else {
                            Text("Save Payment")
                        }
                    }
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(AppColor.backgroundPrimary)
                    .frame(maxWidth: .infinity)
                    .frame(height: 44)
                    .background(isPaymentValid && uiState.isLoggedIn ? brandColor : AppColor.textSecondary)


                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .disabled(!isPaymentValid || uiState.isSavingPayment || !uiState.isLoggedIn)
                }
                .padding(.horizontal, 28)
            } else {
                if uiState.hasPaymentDetails {
                    VStack(alignment: .leading, spacing: 8) {
                        PaymentRow(icon: "person.fill", text: uiState.cardholderName)
                        PaymentRow(icon: "creditcard.fill", text: "•••• \(String(uiState.cardNumber.suffix(4)))")
                        PaymentRow(icon: "calendar", text: "\(uiState.expiryMonth)/\(uiState.expiryYear)")
                    }
                    .padding(.horizontal, 28)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .opacity(uiState.isLoggedIn ? 1 : 0.5)
                } else {
                    EmptyStateView(
                        icon: "creditcard.slash",
                        title: "No Payment Method",
                        message: uiState.isLoggedIn ? "Tap 'Add' to add a payment method" : "Sign in to add payment method"
                    )
                }
            }
        }
        .onChange(of: uiState.cardholderName) { _, newValue in
            if !isEditing { tempCardholderName = newValue }
        }
        .onChange(of: uiState.cardNumber) { _, newValue in
            if !isEditing { tempCardNumber = newValue }
        }
        .onChange(of: uiState.expiryMonth) { _, newValue in
            if !isEditing { tempExpiryMonth = newValue }
        }
        .onChange(of: uiState.expiryYear) { _, newValue in
            if !isEditing { tempExpiryYear = newValue }
        }
        .onChange(of: uiState.cvv) { _, newValue in
            if !isEditing { tempCvv = newValue }
        }
    }
}
