//
//  SignupView.swift
//  shopify-ecommerce-ios
//
//  Created by Ehab Salah on 27/06/2026.
//

import SwiftUI

struct SignupView: View {
    @State var viewmodel: SignupViewModelProtocol
    @State private var showHome = false
    
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
                        hasError: viewmodel.emailError != nil,
                        errorMessage: viewmodel.emailError,
                        text: $viewmodel.email
                    ).padding(.horizontal,-28)
                    
                    CustomTextField(
                        placeholder: "Phone Number",
                        type: .phone,
                        hasError: viewmodel.phoneError != nil,
                        errorMessage: viewmodel.phoneError,
                        text: $viewmodel.phone
                    ).padding(.horizontal,-28)
                    
                    CustomTextField(
                        placeholder: "Password",
                        type: .password,
                        hasError: viewmodel.passwordError != nil,
                        errorMessage: viewmodel.passwordError,
                        text: $viewmodel.password
                    ).padding(.horizontal,-28)
                    
                    CustomTextField(
                        placeholder: "Confirm Password",
                        type: .password,
                        hasError: viewmodel.confirmPasswordError != nil,
                        errorMessage: viewmodel.confirmPasswordError,
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
                    UserDefaults.standard.set(true, forKey: AppConstants.isGuestMode)
                }
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.appPrimary)
            }
        }
        .showLoading(if: viewmodel.isLoading)
        .showCustomAlert(title: "Error", errorMessage: $viewmodel.errorMessage)
        .background(Color.white.ignoresSafeArea())
        .fullScreenCover(isPresented: $showHome) {
            TabBarView()
        }
        .onChange(of: viewmodel.isSignupSuccess) { _, newValue in
            if newValue {
                showHome = true
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
