//
//  SignupViewModel.swift
//  shopify-ecommerce-ios
//
//  Created by Ehab Salah on 27/06/2026.
//

import Foundation

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
    
    private let signupUseCase: SignupUseCase
    
    init(signupUseCase: SignupUseCase = SignupUseCase()) {
        self.signupUseCase = signupUseCase
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
