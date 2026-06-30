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
    var password: String { get set }
    var confirmPassword: String { get set }
    var errorMessage: String? { get set }
    var isLoading: Bool { get }
    var isSignupSuccess: Bool { get }
    
    func signup()
}



@Observable
class SignupViewModel: SignupViewModelProtocol {
    var email = ""
    var password = ""
    var confirmPassword = ""
    
    var errorMessage: String? = nil
    var isLoading = false
    var isSignupSuccess = false
    
    private let signupUseCase: SignupUseCase
    
    init(signupUseCase: SignupUseCase = SignupUseCase()) {
        self.signupUseCase = signupUseCase
    }
    
    func signup() {
        guard !email.isEmpty, !password.isEmpty, !confirmPassword.isEmpty else {
            self.errorMessage = "Please fill in all fields."
            return
        }
        guard password == confirmPassword else {
            self.errorMessage = "Passwords do not match."
            return
        }
        
        self.isLoading = true
        self.errorMessage = nil
        
        Task {
            do {
                try await signupUseCase.execute(email: email, password: password)
                self.isSignupSuccess = true
                self.isLoading = false
            } catch {
                self.errorMessage = error.localizedDescription
                self.isLoading = false
            }
        }
    }
}
