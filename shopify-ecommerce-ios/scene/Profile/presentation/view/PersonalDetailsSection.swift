//
//  PersonalDetailsSection.swift
//  shopify-ecommerce-ios
//
//  Created by Mahmoud Raafat Mustafa on 04/07/2026.
//

import SwiftUI

struct PersonalDetailsSection: View {
    let uiState: ProfileUIState
    @Binding var isEditingName: Bool
 
    
    @Binding var tempFirstName: String
    @Binding var tempLastName: String
    
    let brandColor: Color
    let onSaveName: () -> Void
    private var isNameValid: Bool {
        !tempFirstName.isEmpty && !tempLastName.isEmpty
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Personal Details")
                    .font(.title3).fontWeight(.bold)
                
                Spacer()
                
                if uiState.isLoggedIn && !isEditingName {
                    Button("Edit") {
                        tempFirstName = uiState.firstName
                        tempLastName = uiState.lastName
                        isEditingName = true
                    }
                    .font(.system(size: 14))
                    .foregroundStyle(AppColor.brandPrimary)
                }
            }
            .padding(.horizontal, 28)
            
            if isEditingName {
                CustomTextField(
                    placeholder: "First Name",
                    type: .name,
                    hasError: false,
                    text: $tempFirstName
                )
                .disabled(uiState.isSavingName || !uiState.isLoggedIn)
                .opacity(uiState.isLoggedIn ? 1 : 0.6)
                
                CustomTextField(
                    placeholder: "Last Name",
                    type: .name,
                    hasError: false,
                    text: $tempLastName
                )
                .disabled(uiState.isSavingName || !uiState.isLoggedIn)
                .opacity(uiState.isLoggedIn ? 1 : 0.6)
                
                HStack(spacing: 12) {
                    Button("Cancel") {
                        isEditingName = false
                    }
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(AppColor.textSecondary)
                    .frame(maxWidth: .infinity)
                    .frame(height: 44)
                    
                    Button {
                        onSaveName()
                    } label: {
                        if uiState.isSavingName {
                            ProgressView()
                                .tint(AppColor.backgroundPrimary)
                        } else {
                            Text("Save Name")
                        }
                    }
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(AppColor.backgroundPrimary)
                    .frame(maxWidth: .infinity)
                    .frame(height: 44)
                    .background(isNameValid && uiState.isLoggedIn ? brandColor : AppColor.textSecondary)

                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .disabled(!isNameValid || uiState.isSavingName || !uiState.isLoggedIn)
                }
                .padding(.horizontal, 28)
            } else {
                VStack(alignment: .leading, spacing: 12) {
                    HStack(alignment: .top) {
                        Text("Email:")
                            .font(.subheadline)
                            .foregroundColor(AppColor.textSecondary)
                            .frame(width: 70, alignment: .leading)
                        
                        Text(uiState.email)
                            .font(.subheadline)
                            .foregroundColor(.primary)
                        
                        Spacer()
                        
                        Image(systemName: "lock.fill")
                            .font(.caption)
                            .foregroundColor(AppColor.textSecondary)
                    }
                    
                    HStack(alignment: .top) {
                        Text("Name:")
                            .font(.subheadline)
                            .foregroundColor(AppColor.textSecondary)
                            .frame(width: 70, alignment: .leading)
                        
                        Text("\(uiState.firstName) \(uiState.lastName)")
                            .font(.subheadline)
                            .foregroundColor(uiState.firstName.isEmpty ? AppColor.textSecondary.opacity(0.7) : .primary)
                    }
                }
                .padding(.horizontal, 28)
                .frame(maxWidth: .infinity, alignment: .leading)
                .opacity(uiState.isLoggedIn ? 1 : 0.5)
            }
        }
        .onChange(of: uiState.firstName) { _, newValue in
            if !isEditingName { tempFirstName = newValue }
        }
        .onChange(of: uiState.lastName) { _, newValue in
            if !isEditingName { tempLastName = newValue }
        }
    }
}
