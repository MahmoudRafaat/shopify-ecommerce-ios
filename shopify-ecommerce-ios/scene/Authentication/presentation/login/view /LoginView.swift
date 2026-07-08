//
//  LoginView.swift
//  shopify-ecommerce-ios
//
//  Created by Mahmoud Raafat Mustafa on 27/06/2026.
//

import SwiftUI

struct LoginView: View {
    @State var viewmodel: LoginViewModelProtocol
    @State private var showHome = false
    @State private var navigateToSignup = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack(spacing: 24) {
                    LoginHeaderView()
                    
                    LoginInputView(
                        email: $viewmodel.email,
                        password: $viewmodel.password,
                        errorMessage: viewmodel.errorMessage
                    )
                    
                    VStack(spacing: 16) {
                        CustomButton(text: "Login") {
                            viewmodel.login()
                        }
                        .disabled(viewmodel.isLoading)
                        
                        NavigationLink {
                            TabBarView()
                                .navigationBarBackButtonHidden(true)
                        } label: {
                            Text("Continue as Guest")
                                .font(.subheadline)
                                .foregroundColor(.gray)
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
                .showLoading(if: viewmodel.isLoading)
                .showCustomAlert(title: "Error", errorMessage: $viewmodel.errorMessage)
                .background(Color.white.ignoresSafeArea())
                .disabled(viewmodel.showSuccessMessage)
                
                if viewmodel.showSuccessMessage {
                    VStack {
                        Spacer()
                        Text("Login Successful!")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.green)
                            .cornerRadius(10)
                            .padding(.horizontal, 40)
                            .padding(.bottom, 100)
                            .transition(.move(edge: .bottom).combined(with: .opacity))
                    }
                }
            }
            .animation(.easeInOut(duration: 0.3), value: viewmodel.showSuccessMessage)
            .fullScreenCover(isPresented: $showHome) {
              TabBarView()
            }
            .navigationDestination(isPresented: $navigateToSignup) {
                SignupView(viewmodel: SignupViewModel())
            }
            .onChange(of: viewmodel.isLoginSuccess) { _, newValue in
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
}

#Preview {
    LoginView(viewmodel: LoginViewModel())
}
