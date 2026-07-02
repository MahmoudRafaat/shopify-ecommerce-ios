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
        guard checkValidation() else { return }

        self.isLoading = true
        Task {
            do {
                // Pass nil when phone is empty so the field is omitted entirely
                let sanitizedPhone: String? = phone.isEmpty ? nil : phone
                try await signupUseCase.execute(
                    email: email,
                    password: password,
                    phone: sanitizedPhone
                )
                self.isSignupSuccess = true
            } catch {
                self.errorMessage = error.localizedDescription
            }
            self.isLoading = false
        }
    }

    // MARK: - Validation

    /// Returns `true` when every field is valid; sets per-field errors otherwise.
    @discardableResult
    func checkValidation() -> Bool {
        emailError = nil
        phoneError = nil
        passwordError = nil
        confirmPasswordError = nil
        errorMessage = nil

        var isValid = true

        // --- Email ---
        if email.isEmpty {
            emailError = "Email is required"
            isValid = false
        } else if !isValidEmail(email) {
            emailError = "Please enter a valid email address"
            isValid = false
        }

        // --- Phone (optional, but must be E.164 if provided) ---
        if !phone.isEmpty && !isValidE164Phone(phone) {
            phoneError = "Phone must be in E.164 format (e.g. +201234567890)"
            isValid = false
        }

        // --- Password ---
        if password.isEmpty {
            passwordError = "Password is required"
            isValid = false
        }

        // --- Confirm Password ---
        if confirmPassword.isEmpty {
            confirmPasswordError = "Confirm password is required"
            isValid = false
        } else if password != confirmPassword {
            confirmPasswordError = "Passwords do not match"
            isValid = false
        }

        return isValid
    }

    // MARK: - Private Helpers

    /// Basic RFC-style email check.
    private func isValidEmail(_ email: String) -> Bool {
        let pattern = #"^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"#
        return email.range(of: pattern, options: .regularExpression) != nil
    }

    /// E.164: a leading `+` followed by 7-15 digits (e.g. +201234567890).
    private func isValidE164Phone(_ phone: String) -> Bool {
        let pattern = #"^\+[1-9]\d{6,14}$"#
        return phone.range(of: pattern, options: .regularExpression) != nil
    }
}
