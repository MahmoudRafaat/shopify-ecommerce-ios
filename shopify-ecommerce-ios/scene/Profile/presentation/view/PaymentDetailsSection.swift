struct PaymentDetailsSection: View {
    let uiState: ProfileUIState
    @Binding var isEditing: Bool
    let onSave: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Payment Details")
                    .font(.title3).fontWeight(.bold)
                
                Spacer()
                
                if uiState.isLoggedIn && !isEditing {
                    Button(uiState.hasPaymentDetails ? "Edit" : "Add") {
                        isEditing = true
                    }
                    .font(.system(size: 14))
                    .foregroundStyle(Color.blue)
                }
            }
            .padding(.horizontal, 28)
            
            if isEditing {
                Group {
                    CustomTextField(
                        placeholder: "Cardholder Name",
                        type: .name,
                        hasError: false,
                        text: .constant(uiState.cardholderName)
                    )
                    .disabled(uiState.isSavingPayment || !uiState.isLoggedIn)
                    .opacity(uiState.isLoggedIn ? 1 : 0.6)
                    
                    CustomTextField(
                        placeholder: "Card Number",
                        type: .number,
                        hasError: false,
                        text: .constant(uiState.cardNumber)
                    )
                    .disabled(uiState.isSavingPayment || !uiState.isLoggedIn)
                    .opacity(uiState.isLoggedIn ? 1 : 0.6)
                    
                    HStack(spacing: 12) {
                        CustomTextField(
                            placeholder: "MM",
                            type: .number,
                            hasError: false,
                            text: .constant(uiState.expiryMonth)
                        )
                        .disabled(uiState.isSavingPayment || !uiState.isLoggedIn)
                        .opacity(uiState.isLoggedIn ? 1 : 0.6)
                        .frame(maxWidth: .infinity)
                        
                        CustomTextField(
                            placeholder: "YY",
                            type: .number,
                            hasError: false,
                            text: .constant(uiState.expiryYear)
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
                        text: .constant(uiState.cvv)
                    )
                    .disabled(uiState.isSavingPayment || !uiState.isLoggedIn)
                    .opacity(uiState.isLoggedIn ? 1 : 0.6)
                }
                
                HStack(spacing: 12) {
                    Button("Cancel") {
                        isEditing = false
                    }
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity)
                    .frame(height: 44)
                    
                    Button {
                        onSave()
                    } label: {
                        if uiState.isSavingPayment {
                            ProgressView()
                                .tint(.white)
                        } else {
                            Text("Save Payment")
                        }
                    }
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 44)
                    .background(uiState.isPaymentValid && uiState.isLoggedIn ? Color.blue : Color.gray)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .disabled(!uiState.isPaymentValid || uiState.isSavingPayment || !uiState.isLoggedIn)
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
    }
}
