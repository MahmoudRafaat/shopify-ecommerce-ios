
import SwiftUI

struct AddressSection: View {
    let uiState: ProfileUIState
    @Binding var isEditing: Bool
  
    
    @Binding var tempAddress1: String
    @Binding var tempCity: String
    @Binding var tempProvince: String
    @Binding var tempCountry: String
    @Binding var tempZip: String
    @Binding var tempPhone: String
    let brandColor: Color
    let onSave: () -> Void

    private var isAddressValid: Bool {
        !tempAddress1.isEmpty && !tempCity.isEmpty && !tempProvince.isEmpty && !tempCountry.isEmpty && !tempZip.isEmpty
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Address Details")
                    .font(.title3).fontWeight(.bold)
                
                Spacer()
                
                if uiState.isLoggedIn && !isEditing {
                    Button(uiState.hasAddress ? "Edit" : "Add") {
                        tempAddress1 = uiState.address1
                        tempCity = uiState.city
                        tempProvince = uiState.provinceCode
                        tempCountry = uiState.countryCode
                        tempZip = uiState.zip
                        tempPhone = uiState.phone
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
                        text: $tempAddress1
                    )
                    .disabled(uiState.isSavingAddress || !uiState.isLoggedIn)
                    .opacity(uiState.isLoggedIn ? 1 : 0.6)
                    
                    CustomTextField(
                        placeholder: "City",
                        type: .address,
                        hasError: false,
                        text: $tempCity
                    )
                    .disabled(uiState.isSavingAddress || !uiState.isLoggedIn)
                    .opacity(uiState.isLoggedIn ? 1 : 0.6)
                    
                    CustomTextField(
                        placeholder: "Province/State Code (e.g., ON)",
                        type: .address,
                        hasError: false,
                        text: $tempProvince
                    )
                    .disabled(uiState.isSavingAddress || !uiState.isLoggedIn)
                    .opacity(uiState.isLoggedIn ? 1 : 0.6)
                    
                    CustomTextField(
                        placeholder: "Country Code (e.g., CA)",
                        type: .address,
                        hasError: false,
                        text: $tempCountry
                    )
                    .disabled(uiState.isSavingAddress || !uiState.isLoggedIn)
                    .opacity(uiState.isLoggedIn ? 1 : 0.6)
                    
                    CustomTextField(
                        placeholder: "ZIP/Postal Code",
                        type: .number,
                        hasError: false,
                        text: $tempZip
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
                    .background(isAddressValid && uiState.isLoggedIn ? brandColor : Color.gray)

                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .disabled(!isAddressValid || uiState.isSavingAddress || !uiState.isLoggedIn)
                }
                .padding(.horizontal, 28)
            } else {
                if uiState.hasAddress {
                    VStack(alignment: .leading, spacing: 8) {
                        AddressRow(icon: "map.fill", text: uiState.province)
                
                        AddressRow(icon: "globe", text: uiState.country)
                        
                      
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
        .onChange(of: uiState.address1) { _, newValue in
            if !isEditing { tempAddress1 = newValue }
        }
        .onChange(of: uiState.city) { _, newValue in
            if !isEditing { tempCity = newValue }
        }
        .onChange(of: uiState.provinceCode) { _, newValue in
            if !isEditing { tempProvince = newValue }
        }
        .onChange(of: uiState.countryCode) { _, newValue in
            if !isEditing { tempCountry = newValue }
        }
        .onChange(of: uiState.zip) { _, newValue in
            if !isEditing { tempZip = newValue }
        }
        .onChange(of: uiState.phone) { _, newValue in
            if !isEditing { tempPhone = newValue }
        }
    }
}
