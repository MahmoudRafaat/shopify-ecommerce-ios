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
    
    var emailError: String? { get set }
    var phoneError: String? { get set }
    var passwordError: String? { get set }
    var confirmPasswordError: String? { get set }
    
    var errorMessage: String? { get set }
    var isLoading: Bool { get }
    var isSignupSuccess: Bool { get }
    
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
    
    var emailError: String? = nil
    var phoneError: String? = nil
    var passwordError: String? = nil
    var confirmPasswordError: String? = nil
    
    var errorMessage: String? = nil
    var isLoading = false
    var isSignupSuccess = false
    
    var showPhonePopup = false
    var googlePhone = ""
    
    private var pendingGoogleCredential: AuthCredential? = nil
    private var pendingGoogleEmail: String = ""
    private var pendingGoogleFirstName: String? = nil
    private var pendingGoogleLastName: String? = nil
    
    private let signupUseCase: SignupUseCase
    private let googleAuthUseCase: GoogleAuthUseCase
    
    init(signupUseCase: SignupUseCase = SignupUseCase(), googleAuthUseCase: GoogleAuthUseCase = GoogleAuthUseCase()) {
        self.signupUseCase = signupUseCase
        self.googleAuthUseCase = googleAuthUseCase
    }
    
    func signup() {
        checkValidation()
        self.isLoading = true
        Task {
            do {
                try await signupUseCase.execute(email: email, password: password, phone: phone)
                UserDefaults.standard.set(true, forKey: AppConstants.isLoggedIn)
                self.isSignupSuccess = true
                self.isLoading = false
            } catch {
                self.errorMessage = error.localizedDescription
                self.isLoading = false
            }
        }
    }
    
    func loginWithGoogle(presenting: UIViewController) {
        isLoading = true
        errorMessage = nil
        isSignupSuccess = false
        
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            self.errorMessage = "Firebase configuration error."
            self.isLoading = false
            return
        }
        
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        GIDSignIn.sharedInstance.signIn(withPresenting: presenting) { [weak self] result, error in
            guard let self = self else { return }
            
            if let error = error {
                Task { @MainActor in
                    self.isLoading = false
                    self.errorMessage = error.localizedDescription
                }
                return
            }
            
            guard let user = result?.user,
                  let idToken = user.idToken?.tokenString else {
                Task { @MainActor in
                    self.isLoading = false
                    self.errorMessage = "Failed to get Google ID token."
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
                self.pendingGoogleCredential = credential
                self.pendingGoogleEmail = email
                self.pendingGoogleFirstName = firstName
                self.pendingGoogleLastName = lastName
                self.isLoading = false
                self.showPhonePopup = true
            }
        }
    }
    
    func submitGooglePhone() {
        guard !googlePhone.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            self.errorMessage = "Please enter a valid phone number."
            return
        }
        
        guard let credential = pendingGoogleCredential else { return }
        let email = pendingGoogleEmail
        
        isLoading = true
        errorMessage = nil
        isSignupSuccess = false
        showPhonePopup = false
        
        Task { @MainActor in
            defer { self.isLoading = false }
            
            do {
                let result = try await self.googleAuthUseCase.execute(
                    credential: credential,
                    email: email,
                    phone: googlePhone
                )
                
                UserDefaults.standard.set(result.firebaseUser.uid, forKey: "firebase_user_id")
                
                if let customerId = result.shopifyCustomer.id {
                    UserDefaults.standard.set(customerId, forKey: "shopify_customer_id")
                }
                
                UserDefaults.standard.set(email, forKey: "user_email")
                UserDefaults.standard.set(true, forKey: AppConstants.isLoggedIn)
                
                self.isSignupSuccess = true
                self.errorMessage = nil
            } catch {
                if let loginError = error as? LoginError {
                    self.errorMessage = loginError.errorDescription ?? "Google Login failed. Please try again."
                } else {
                    self.errorMessage = "Something went wrong. Please try again."
                }
                self.isSignupSuccess = false
            }
        }
    }
    
    func checkValidation(){
        emailError = nil
        phoneError = nil
        passwordError = nil
        confirmPasswordError = nil
        errorMessage = nil
        
        var isValid = true
        
        if email.isEmpty {
            emailError = "Email is required"
            isValid = false
        }
        if phone.isEmpty {
            phoneError = "Phone number is required"
            isValid = false
        }
        if password.isEmpty {
            passwordError = "Password is required"
            isValid = false
        }
        if confirmPassword.isEmpty {
            confirmPasswordError = "Confirm password is required"
            isValid = false
        } else if password != confirmPassword {
            confirmPasswordError = "Passwords do not match"
            isValid = false
        }
        
        guard isValid else {
            return
        }
        
    }
    
    
}
