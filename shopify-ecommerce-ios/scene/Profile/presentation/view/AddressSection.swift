
struct AddressSection: View {
    let uiState: ProfileUIState
    @Binding var isEditing: Bool
    let onSave: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Address Details")
                    .font(.title3).fontWeight(.bold)
                
                Spacer()
                
                if uiState.isLoggedIn && !isEditing {
                    Button(uiState.hasAddress ? "Edit" : "Add") {
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
                        placeholder: "Address Line",
                        type: .address,
                        hasError: false,
                        text: .constant(uiState.address1)
                    )
                    .disabled(uiState.isSavingAddress || !uiState.isLoggedIn)
                    .opacity(uiState.isLoggedIn ? 1 : 0.6)
                    
                    CustomTextField(
                        placeholder: "City",
                        type: .address,
                        hasError: false,
                        text: .constant(uiState.city)
                    )
                    .disabled(uiState.isSavingAddress || !uiState.isLoggedIn)
                    .opacity(uiState.isLoggedIn ? 1 : 0.6)
                    
                    CustomTextField(
                        placeholder: "Province/State",
                        type: .address,
                        hasError: false,
                        text: .constant(uiState.province)
                    )
                    .disabled(uiState.isSavingAddress || !uiState.isLoggedIn)
                    .opacity(uiState.isLoggedIn ? 1 : 0.6)
                    
                    CustomTextField(
                        placeholder: "Country",
                        type: .address,
                        hasError: false,
                        text: .constant(uiState.country)
                    )
                    .disabled(uiState.isSavingAddress || !uiState.isLoggedIn)
                    .opacity(uiState.isLoggedIn ? 1 : 0.6)
                    
                    CustomTextField(
                        placeholder: "ZIP/Postal Code",
                        type: .number,
                        hasError: false,
                        text: .constant(uiState.zip)
                    )
                    .disabled(uiState.isSavingAddress || !uiState.isLoggedIn)
                    .opacity(uiState.isLoggedIn ? 1 : 0.6)
                    
                    CustomTextField(
                        placeholder: "Phone (Optional)",
                        type: .phone,
                        hasError: false,
                        text: .constant(uiState.phone)
                    )
                    .disabled(uiState.isSavingAddress || !uiState.isLoggedIn)
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
                        if uiState.isSavingAddress {
                            ProgressView()
                                .tint(.white)
                        } else {
                            Text("Save Address")
                        }
                    }
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 44)
                    .background(uiState.isAddressValid && uiState.isLoggedIn ? Color.blue : Color.gray)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .disabled(!uiState.isAddressValid || uiState.isSavingAddress || !uiState.isLoggedIn)
                }
                .padding(.horizontal, 28)
            } else {
                if uiState.hasAddress {
                    VStack(alignment: .leading, spacing: 8) {
                        AddressRow(icon: "location.fill", text: uiState.address1)
                        AddressRow(icon: "city.fill", text: uiState.city)
                        AddressRow(icon: "map.fill", text: uiState.province)
                        AddressRow(icon: "globe", text: uiState.country)
                        AddressRow(icon: "envelope.fill", text: uiState.zip)
                        if !uiState.phone.isEmpty {
                            AddressRow(icon: "phone.fill", text: uiState.phone)
                        }
                    }
                    .padding(.horizontal, 28)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .opacity(uiState.isLoggedIn ? 1 : 0.5)
                } else {
                    EmptyStateView(
                        icon: "location.slash",
                        title: "No Address Added",
                        message: uiState.isLoggedIn ? "Tap 'Add' to add your shipping address" : "Sign in to add your address"
                    )
                }
            }
        }
    }
}
