// MARK: - Personal Details Section

struct PersonalDetailsSection: View {
    let uiState: ProfileUIState
    @Binding var isEditingName: Bool
    @Binding var isEditingEmail: Bool
    let onSaveName: () -> Void
    let onSaveEmail: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Personal Details")
                    .font(.title3).fontWeight(.bold)
                
                Spacer()
                
                if uiState.isLoggedIn && !isEditingName && !isEditingEmail {
                    Button("Edit") {
                        isEditingName = true
                    }
                    .font(.system(size: 14))
                    .foregroundStyle(Color.blue)
                }
            }
            .padding(.horizontal, 28)
            
            if isEditingName {
                // Name editing
                CustomTextField(
                    placeholder: "First Name",
                    type: .name,
                    hasError: false,
                    text: .constant(uiState.firstName)
                )
                .disabled(uiState.isSavingName || !uiState.isLoggedIn)
                .opacity(uiState.isLoggedIn ? 1 : 0.6)
                
                CustomTextField(
                    placeholder: "Last Name",
                    type: .name,
                    hasError: false,
                    text: .constant(uiState.lastName)
                )
                .disabled(uiState.isSavingName || !uiState.isLoggedIn)
                .opacity(uiState.isLoggedIn ? 1 : 0.6)
                
                HStack(spacing: 12) {
                    Button("Cancel") {
                        isEditingName = false
                    }
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity)
                    .frame(height: 44)
                    
                    Button {
                        onSaveName()
                    } label: {
                        if uiState.isSavingName {
                            ProgressView()
                                .tint(.white)
                        } else {
                            Text("Save Name")
                        }
                    }
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 44)
                    .background(uiState.isNameValid && uiState.isLoggedIn ? Color.blue : Color.gray)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .disabled(!uiState.isNameValid || uiState.isSavingName || !uiState.isLoggedIn)
                }
                .padding(.horizontal, 28)
            } else if isEditingEmail {
                // Email editing
                CustomTextField(
                    placeholder: "Email",
                    type: .email,
                    hasError: false,
                    text: .constant(uiState.email)
                )
                .disabled(uiState.isSavingEmail || !uiState.isLoggedIn)
                .opacity(uiState.isLoggedIn ? 1 : 0.6)
                
                HStack(spacing: 12) {
                    Button("Cancel") {
                        isEditingEmail = false
                    }
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity)
                    .frame(height: 44)
                    
                    Button {
                        onSaveEmail()
                    } label: {
                        if uiState.isSavingEmail {
                            ProgressView()
                                .tint(.white)
                        } else {
                            Text("Save Email")
                        }
                    }
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 44)
                    .background(uiState.isEmailValid && uiState.isLoggedIn ? Color.blue : Color.gray)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .disabled(!uiState.isEmailValid || uiState.isSavingEmail || !uiState.isLoggedIn)
                }
                .padding(.horizontal, 28)
            } else {
                // Display mode
                VStack(alignment: .leading, spacing: 12) {
                    DetailRow(label: "Name", value: "\(uiState.firstName) \(uiState.lastName)")
                    DetailRow(label: "Email", value: uiState.email)
                }
                .padding(.horizontal, 28)
                .frame(maxWidth: .infinity, alignment: .leading)
                .opacity(uiState.isLoggedIn ? 1 : 0.5)
            }
        }
    }
}