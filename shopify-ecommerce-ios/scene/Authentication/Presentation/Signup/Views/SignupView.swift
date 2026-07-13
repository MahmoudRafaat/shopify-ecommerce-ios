//
//  SignupView.swift
//  shopify-ecommerce-ios
//
//  Created by Ehab Salah on 27/06/2026.
//

import SwiftUI

struct SignupView: View {
    @State var viewmodel: SignupViewModelProtocol
    
    @AppStorage(AppConstants.isGuestMode) private var isGuestMode = false
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        
        ScrollView(.vertical){
            VStack(alignment: .leading, spacing: 24) {
                
                // MARK: - Header
                SignupHeader()
                // MARK: - Input Fields
                VStack(spacing: 20) {
                    CustomTextField(
                        placeholder: "Username or Email",
                        type: .email,
                        hasError: viewmodel.uiState.emailError != nil,
                        errorMessage: viewmodel.uiState.emailError,
                        text: $viewmodel.email
                    ).padding(.horizontal,-28)
                    
                    CustomTextField(
                        placeholder: "Phone Number",
                        type: .phone,
                        hasError: viewmodel.uiState.phoneError != nil,
                        errorMessage: viewmodel.uiState.phoneError,
                        text: $viewmodel.phone
                    ).padding(.horizontal,-28)
                    
                    CustomTextField(
                        placeholder: "Password",
                        type: .password,
                        hasError: viewmodel.uiState.passwordError != nil,
                        errorMessage: viewmodel.uiState.passwordError,
                        text: $viewmodel.password
                    ).padding(.horizontal,-28)
                    
                    CustomTextField(
                        placeholder: "Confirm Password",
                        type: .password,
                        hasError: viewmodel.uiState.confirmPasswordError != nil,
                        errorMessage: viewmodel.uiState.confirmPasswordError,
                        text: $viewmodel.confirmPassword
                    ).padding(.horizontal,-28)
                }
                .padding(.top, 10)
                
                // MARK: - Login Button (Custom Button)
                CustomButton(text: "Create Account", action: {
                    viewmodel.signup()
                })
                // MARK: - Social Login Divider
                HStack() {
                    Spacer()
                    SocialLoginView(
                        onGoogleTap: {
                            if let rootVC = UIApplication.shared.rootViewController {
                                viewmodel.loginWithGoogle(presenting: rootVC)
                            }
                        },
                    )
                    Spacer()
                }
                // MARK: - Footer (Sign Up)
                SignupFooter()
                    .padding(.bottom, 20)
            }
            .padding(.horizontal, 24)
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Skip") {
                    isGuestMode = true
                    dismiss()
                }
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.appPrimary)
            }
        }
        .showLoading(if: viewmodel.uiState.isLoading)
        .onChange(of: viewmodel.uiState.error) { _, error in
            if let error = error {
                AlertManager.shared.showError(error)
                viewmodel.uiState.error = nil
            }
        }
        .background(AppColor.backgroundPrimary.ignoresSafeArea())
        .onChange(of: viewmodel.uiState.isSignupSuccess) { _, newValue in
            if newValue {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    dismiss()
                }
            }
        }

        .sheet(isPresented: $viewmodel.showPhonePopup) {
            GooglePhoneSheet(
                googlePhone: $viewmodel.googlePhone,
                onSubmit: { viewmodel.submitGooglePhone() }
            )
        }
    }
}

#Preview {
    SignupView(viewmodel: AuthFactory.makeSignupViewModel())
}
