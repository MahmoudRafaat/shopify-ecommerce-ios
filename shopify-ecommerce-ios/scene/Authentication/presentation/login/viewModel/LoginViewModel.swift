//
//  LoginViewModel.swift
//  shopify-ecommerce-ios
//
//  Created by Mahmoud Raafat Mustafa on 30/06/2026.
//

import Foundation

@MainActor
protocol LoginViewModelProtocol: AnyObject {
    var email: String { get set }
    var password: String { get set }
    var errorMessage: String? { get set }
    var isLoading: Bool { get }
    var isLoginSuccess: Bool { get }
    var showSuccessMessage: Bool { get }
    
    func login()
    func resetState()
}

@Observable
class LoginViewModel: LoginViewModelProtocol {
    var email = ""
    var password = ""
    
    var errorMessage: String? = nil
    private(set) var isLoading = false
    private(set) var isLoginSuccess = false
    private(set) var showSuccessMessage = false
    
    private let loginUseCase: LoginUseCase
    
    init(loginUseCase: LoginUseCase = LoginUseCase()) {
        self.loginUseCase = loginUseCase
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
    }
}

extension String {
    var trimmed: String {
        trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
