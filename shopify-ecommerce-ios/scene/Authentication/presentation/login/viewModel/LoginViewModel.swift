//
//  LoginViewModel.swift
//  shopify-ecommerce-ios
//
//  Created by Mahmoud Raafat Mustafa on 30/06/2026.
//

import Foundation
import UIKit
import GoogleSignIn
import FirebaseAuth
import FirebaseCore

@MainActor
protocol LoginViewModelProtocol: AnyObject {
    var email: String { get set }
    var password: String { get set }
    var errorMessage: String? { get set }
    var isLoading: Bool { get }
    var isLoginSuccess: Bool { get }
    var showSuccessMessage: Bool { get }
    
    func login()
    func loginWithGoogle(presenting: UIViewController)
    func resetState()
    
    var showPhonePopup: Bool { get set }
    var googlePhone: String { get set }
    func submitGooglePhone()
}

@Observable
class LoginViewModel: LoginViewModelProtocol {
    var email = ""
    var password = ""
    
    var errorMessage: String? = nil
    private(set) var isLoading = false
    private(set) var isLoginSuccess = false
    private(set) var showSuccessMessage = false
    
    var showPhonePopup = false
    var googlePhone = ""
    
    private var pendingGoogleCredential: AuthCredential? = nil
    private var pendingGoogleEmail: String = ""
    private var pendingGoogleFirstName: String? = nil
    private var pendingGoogleLastName: String? = nil
    
    private let loginUseCase: LoginUseCase
    private let googleAuthUseCase: GoogleAuthUseCase
    
    init(loginUseCase: LoginUseCase = LoginUseCase(), googleAuthUseCase: GoogleAuthUseCase = GoogleAuthUseCase()) {
        self.loginUseCase = loginUseCase
        self.googleAuthUseCase = googleAuthUseCase
    }
    
    func login() {
        guard !email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            self.errorMessage = "Please enter your email address."
            return
        }
        
        guard !password.isEmpty else {
            self.errorMessage = "Please enter your password."
            return
        }
        
        guard isValidEmail(email) else {
            self.errorMessage = "Please enter a valid email address."
            return
        }
        
        isLoading = true
        errorMessage = nil
        isLoginSuccess = false
        showSuccessMessage = false
        
        Task { @MainActor in
            defer {
                isLoading = false
            }
            
            do {
                let result = try await loginUseCase.execute(email: email.trimmed, password: password)
                
                storeUserData(result)
                
                showSuccessMessage = true
                
                try? await Task.sleep(nanoseconds: 2_000_000_000)
                
                isLoginSuccess = true
                errorMessage = nil
                
            } catch {
                if let loginError = error as? LoginError {
                    errorMessage = loginError.errorDescription ?? "Login failed. Please try again."
                } else {
                    errorMessage = "Something went wrong. Please try again."
                }
                isLoginSuccess = false
                showSuccessMessage = false
            }
        }
    }
    
    func loginWithGoogle(presenting: UIViewController) {
        isLoading = true
        errorMessage = nil
        isLoginSuccess = false
        showSuccessMessage = false
        
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
                do {
                    let result = try await self.googleAuthUseCase.execute(
                        credential: credential,
                        email: email,
                        phone: nil
                    )
                    
                    self.email = email // For storing user data
                    self.storeUserData(result)
                    
                    self.showSuccessMessage = true
                    try? await Task.sleep(nanoseconds: 2_000_000_000)
                    
                    self.isLoginSuccess = true
                    self.errorMessage = nil
                    self.isLoading = false
                    
                } catch LoginError.phoneRequiredForGoogleAuth {
                    self.pendingGoogleCredential = credential
                    self.pendingGoogleEmail = email
                    self.pendingGoogleFirstName = firstName
                    self.pendingGoogleLastName = lastName
                    self.isLoading = false
                    self.showPhonePopup = true
                } catch {
                    if let loginError = error as? LoginError {
                        self.errorMessage = loginError.errorDescription ?? "Google Login failed. Please try again."
                    } else {
                        self.errorMessage = "Something went wrong. Please try again."
                    }
                    self.isLoginSuccess = false
                    self.showSuccessMessage = false
                    self.isLoading = false
                }
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
        isLoginSuccess = false
        showSuccessMessage = false
        showPhonePopup = false
        
        Task { @MainActor in
            defer { self.isLoading = false }
            
            do {
                let result = try await self.googleAuthUseCase.execute(
                    credential: credential,
                    email: email,
                    phone: googlePhone
                )
                
                self.email = email // For storing user data
                self.storeUserData(result)
                
                self.showSuccessMessage = true
                try? await Task.sleep(nanoseconds: 2_000_000_000)
                
                self.isLoginSuccess = true
                self.errorMessage = nil
            } catch {
                if let loginError = error as? LoginError {
                    self.errorMessage = loginError.errorDescription ?? "Google Login failed. Please try again."
                } else {
                    self.errorMessage = "Something went wrong. Please try again."
                }
                self.isLoginSuccess = false
                self.showSuccessMessage = false
            }
        }
    }
    
    func resetState() {
        email = ""
        password = ""
        errorMessage = nil
        isLoading = false
        isLoginSuccess = false
        showSuccessMessage = false
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    private func storeUserData(_ result: LoginResult) {
        UserDefaults.standard.set(result.firebaseUser.uid, forKey: "firebase_user_id")
        
        if let customerId = result.shopifyCustomer.id {
            UserDefaults.standard.set(customerId, forKey: "shopify_customer_id")
        }
        
        UserDefaults.standard.set(email, forKey: "user_email")
        UserDefaults.standard.set(true, forKey: AppConstants.isLoggedIn)
    }
}

extension String {
    var trimmed: String {
        trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
