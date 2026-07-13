//
//  SignupViewModel.swift
//  shopify-ecommerce-ios
//
//  Created by Ehab Salah on 27/06/2026.
//

import Foundation
import UIKit
import GoogleSignIn
import FirebaseAuth
import FirebaseCore

@MainActor
protocol SignupViewModelProtocol {
    var email: String { get set }
    var phone: String { get set }
    var password: String { get set }
    var confirmPassword: String { get set }
    
    var uiState: SignupUIState { get set }
    
    func signup()
    func loginWithGoogle(presenting: UIViewController)
    
    var showPhonePopup: Bool { get set }
    var googlePhone: String { get set }
    func submitGooglePhone()
}



@Observable
class SignupViewModel: SignupViewModelProtocol {
    var email = ""
    var phone = ""
    var password = ""
    var confirmPassword = ""
    
    var uiState = SignupUIState()
    
    var showPhonePopup = false
    var googlePhone = ""
    
    private var pendingGoogleCredential: AuthCredential? = nil
    private var pendingGoogleEmail: String = ""
    private var pendingGoogleFirstName: String? = nil
    private var pendingGoogleLastName: String? = nil
    
    private let signupUseCase: SignupUseCase
    private let googleAuthUseCase: GoogleAuthUseCase
    
    init(signupUseCase: SignupUseCase, googleAuthUseCase: GoogleAuthUseCase) {
        self.signupUseCase = signupUseCase
        self.googleAuthUseCase = googleAuthUseCase
    }
    
    func signup() {
        checkValidation()
        guard uiState.emailError == nil && uiState.phoneError == nil && uiState.passwordError == nil && uiState.confirmPasswordError == nil else { return }
        
        self.uiState.isLoading = true
        Task {
            do {
                try await signupUseCase.execute(email: email, password: password, phone: phone)
                UserDefaults.standard.set(true, forKey: AppConstants.isLoggedIn)
                self.uiState.isSignupSuccess = true
                self.uiState.isLoading = false
            } catch {
                self.uiState.error = AppError.custom(title: "Error", message: error.localizedDescription)
                self.uiState.isLoading = false
            }
        }
    }
    
    func loginWithGoogle(presenting: UIViewController) {
        uiState.isLoading = true
        uiState.error = nil
        uiState.isSignupSuccess = false
        
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            self.uiState.error = AppError.custom(title: "Error", message: "Firebase configuration error.")
            self.uiState.isLoading = false
            return
        }
        
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        GIDSignIn.sharedInstance.signIn(withPresenting: presenting) { [weak self] result, error in
            guard let self = self else { return }
            
            if let error = error {
                Task { @MainActor in
                    self.uiState.isLoading = false
                    self.uiState.error = AppError.custom(title: "Error", message: error.localizedDescription)
                }
                return
            }
            
            guard let user = result?.user,
                  let idToken = user.idToken?.tokenString else {
                Task { @MainActor in
                    self.uiState.isLoading = false
                    self.uiState.error = AppError.custom(title: "Error", message: "Failed to get Google ID token.")
                }
                return
            }
            
            let accessToken = user.accessToken.tokenString
            let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                           accessToken: accessToken)
            let email = user.profile?.email ?? ""
            let firstName = user.profile?.givenName ?? ""
            let lastName = user.profile?.familyName ?? ""
            
            Task { @MainActor in
                do {
                    let result = try await self.googleAuthUseCase.execute(
                        credential: credential,
                        email: email,
                        phone: nil
                    )
                    
                    UserDefaults.standard.set(result.firebaseUser.uid, forKey: "firebase_user_id")
                    
                    UserDefaults.standard.set(result.shopifyCustomer.id, forKey: "shopify_customer_id")
                    
                    UserDefaults.standard.set(email, forKey: "user_email")
                    UserDefaults.standard.set(true, forKey: AppConstants.isLoggedIn)
                    
                    self.uiState.isSignupSuccess = true
                    self.uiState.error = nil
                    self.uiState.isLoading = false
                    
                } catch LoginError.phoneRequiredForGoogleAuth {
                    self.pendingGoogleCredential = credential
                    self.pendingGoogleEmail = email
                    self.pendingGoogleFirstName = firstName
                    self.pendingGoogleLastName = lastName
                    self.uiState.isLoading = false
                    self.showPhonePopup = true
                } catch {
                    if let loginError = error as? LoginError {
                        self.uiState.error = AppError.custom(title: "Error", message: loginError.errorDescription ?? "Google Login failed. Please try again.")
                    } else {
                        self.uiState.error = AppError.determine()
                    }
                    self.uiState.isSignupSuccess = false
                    self.uiState.isLoading = false
                }
            }
        }
    }
    
    func submitGooglePhone() {
        guard !googlePhone.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            self.uiState.error = AppError.custom(title: "Error", message: "Please enter a valid phone number.")
            return
        }
        
        guard let credential = pendingGoogleCredential else { return }
        let email = pendingGoogleEmail
        
        uiState.isLoading = true
        uiState.error = nil
        uiState.isSignupSuccess = false
        showPhonePopup = false
        
        Task { @MainActor in
            defer { self.uiState.isLoading = false }
            
            do {
                let result = try await self.googleAuthUseCase.execute(
                    credential: credential,
                    email: email,
                    phone: googlePhone
                )
                
                UserDefaults.standard.set(result.firebaseUser.uid, forKey: "firebase_user_id")
                
                UserDefaults.standard.set(result.shopifyCustomer.id, forKey: "shopify_customer_id")
                
                UserDefaults.standard.set(email, forKey: "user_email")
                UserDefaults.standard.set(true, forKey: AppConstants.isLoggedIn)
                
                self.uiState.isSignupSuccess = true
                self.uiState.error = nil
            } catch {
                if let loginError = error as? LoginError {
                    self.uiState.error = AppError.custom(title: "Error", message: loginError.errorDescription ?? "Google Login failed. Please try again.")
                } else {
                    self.uiState.error = AppError.determine()
                }
                self.uiState.isSignupSuccess = false
            }
        }
    }
    
    func checkValidation(){
        uiState.emailError = nil
        uiState.phoneError = nil
        uiState.passwordError = nil
        uiState.confirmPasswordError = nil
        uiState.error = nil
        
        var isValid = true
        
        if email.isEmpty {
            uiState.emailError = "Email is required"
            isValid = false
        }
        if phone.isEmpty {
            uiState.phoneError = "Phone number is required"
            isValid = false
        }
        if password.isEmpty {
            uiState.passwordError = "Password is required"
            isValid = false
        }
        if confirmPassword.isEmpty {
            uiState.confirmPasswordError = "Confirm password is required"
            isValid = false
        } else if password != confirmPassword {
            uiState.confirmPasswordError = "Passwords do not match"
            isValid = false
        }
        
        guard isValid else {
            return
        }
        
    }
    
    
}
