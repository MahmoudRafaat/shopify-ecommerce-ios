//
//  CheckoutDetailsView.swift
//  shopify-ecommerce-ios
//
//  Created by Mahmoud Raafat Mustafa on 02/07/2026.
//



import SwiftUI

struct ProfileDetailsView: View {
   
    
    @State private var uiState = ProfileUIState(
        email: "mahmoud@gmail.com",
        name: "mahmoud raafat"
      
    )
        
    // primary Color
    let brandRed = Color(red: 0.95, green: 0.25, blue: 0.40)
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    
                    ProfilePhotoEditView()
                        .padding(.top, 16)
                    
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Personal Details")
                            .font(.title3).fontWeight(.bold)
                            .padding(.horizontal, 28)
                        
                       
                        VStack(alignment: .trailing, spacing: 16) {
                            CustomTextField(placeholder: "Email", type: .email, hasError: false, text: $uiState.email)
                                .disabled(true)
                                .opacity(0.6)
                            CustomTextField(placeholder: "First Name", type: .name, hasError: false, text: $uiState.firstName)
                            CustomTextField(placeholder: "Second Name", type: .name, hasError: false, text: $uiState.secondName)
                            Button("Change Password") {
                                // Navigate to change password flow
                            }
                            .font(.system(size: 14))
                            .foregroundStyle(brandRed)
                            .padding(.trailing, 28)
                        }
                    }
                    
                    Divider().padding(.horizontal, 28)
                    
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Address Details")
                            .font(.title3).fontWeight(.bold)
                            .padding(.horizontal, 28)
                        
                        CustomTextField(placeholder: "Pincode", type: .number, hasError: false, text: $uiState.pincode)
                        CustomTextField(placeholder: "Address", type: .address, hasError: false, text: $uiState.address)
                        CustomTextField(placeholder: "City", type: .address, hasError: false, text: $uiState.city)
                        CustomTextField(placeholder: "Country", type: .address, hasError: false, text: $uiState.country)
                    }
                    
                    Divider().padding(.horizontal, 28)
                    
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Bank Account Details")
                            .font(.title3).fontWeight(.bold)
                            .padding(.horizontal, 28)
                        
                        CustomTextField(placeholder: "Account Holder", type: .name, hasError: false, text: $uiState.name)
                        CustomTextField(placeholder: "Bank Account Number", type: .number, hasError: false, text: $uiState.bankAccountNumber)
                        CustomTextField(placeholder: "IFSC Code", type: .number, hasError: false, text: $uiState.ifscCode)
                    }
                    
                    Button {
                        // Action: Send uiState data back to ViewModel to save
                    } label: {
                        Text("Save & Continue")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 54)
                            .background(uiState.isFormValid ? brandRed : Color.gray)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                    .disabled(!uiState.isFormValid)
                    .padding(.horizontal, 28)
                    .padding(.top, 16)
                    .padding(.bottom, 40)
                }
            }
            .background(Color(white: 0.99))
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    ProfileDetailsView()
}
