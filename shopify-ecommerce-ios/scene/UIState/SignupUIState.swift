//
//  SignupUIState.swift
//  shopify-ecommerce-ios
//

import Foundation

struct SignupUIState {
    var isLoading: Bool = false
    var isSignupSuccess: Bool = false
    var error: AppError? = nil
    var emailError: String? = nil
    var phoneError: String? = nil
    var passwordError: String? = nil
    var confirmPasswordError: String? = nil
}
