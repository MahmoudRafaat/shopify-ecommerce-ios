//
//  LoginView.swift
//  shopify-ecommerce-ios
//
//  Created by Mahmoud Raafat Mustafa on 27/06/2026.
//

import SwiftUI

struct LoginView: View {
    @State var viewmodel: LoginViewModelProtocol
    @State private var navigateToSignup = false
    @AppStorage(AppConstants.isGuestMode) private var isGuestMode = false
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack(spacing: 24) {
                    LoginHeaderView()
                    
                    LoginInputView(
                        email: $viewmodel.email,
                        password: $viewmodel.password,
                        errorMessage: viewmodel.uiState.error?.message
                    )
                    
                    VStack(spacing: 16) {
                        CustomButton(text: "Login") {
                            viewmodel.login()
                        }
                        .disabled(viewmodel.uiState.isLoading)
                        
                        Button {
                            isGuestMode = true
                            dismiss()
                        } label: {
                            Text("Continue as Guest")
                                .font(.subheadline)
                                .foregroundColor(AppColor.textSecondary)
                        }
                    }
                    .padding(.top, 10)
                    
                    Spacer()
                    
                    SocialLoginView(
                        onGoogleTap: {
                            if let rootVC = UIApplication.shared.rootViewController {
                                viewmodel.loginWithGoogle(presenting: rootVC)
                            }
                        },
                    )
                    
                    Spacer()
                    
                    LoginFooterView(onSignUp: {
                        navigateToSignup = true
                    })
                }
                .padding(.horizontal, 24)
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
                .disabled(viewmodel.uiState.showSuccessMessage)
                
                if viewmodel.uiState.showSuccessMessage {
                    VStack {
                        Spacer()
                        Text("Login Successful!")
                            .font(.headline)
                            .foregroundColor(AppColor.backgroundPrimary)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(AppColor.successDefault)
                            .cornerRadius(10)
                            .padding(.horizontal, 40)
                            .padding(.bottom, 100)
                            .transition(.move(edge: .bottom).combined(with: .opacity))
                    }
                }
            }
            .animation(.easeInOut(duration: 0.3), value: viewmodel.uiState.showSuccessMessage)
            .onChange(of: viewmodel.uiState.showSuccessMessage) { _, newValue in
                if newValue {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        dismiss()
                    }
                }
            }
            .navigationDestination(isPresented: $navigateToSignup) {
                SignupView(viewmodel: AuthFactory.makeSignupViewModel())
            }
            .sheet(isPresented: $viewmodel.showPhonePopup) {
                GooglePhoneSheet(
                    googlePhone: $viewmodel.googlePhone,
                    onSubmit: { viewmodel.submitGooglePhone() }
                )
            }
        }
    }
}

#Preview {
    LoginView(viewmodel: AuthFactory.makeLoginViewModel())
}
