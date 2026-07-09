//
//  LoginUIState.swift
//  shopify-ecommerce-ios
//

import Foundation

struct LoginUIState {
    var isLoading: Bool = false
    var isLoginSuccess: Bool = false
    var showSuccessMessage: Bool = false
    var error: AppError? = nil
}
