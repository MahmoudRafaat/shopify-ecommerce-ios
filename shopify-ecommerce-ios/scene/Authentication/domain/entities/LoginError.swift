//
//  LoginError.swift
//  shopify-ecommerce-ios
//
//  Created by Mahmoud Raafat Mustafa on 30/06/2026.
//

import Foundation

enum LoginError: LocalizedError {
    case firebaseUserNotFound
    case shopifyCustomerNotFound
    case invalidEmail
    case invalidCredentials
    case accountDisabled
    case networkError(String)
    case tooManyAttempts
    case emailAlreadyInUse
    case weakPassword
    case missingEmail
    case operationNotAllowed
    case requiresRecentLogin
    case providerAlreadyLinked
    case credentialAlreadyInUse
    case internalError
    case appNotAuthorized
    case appVerificationDisabled
    case captchaCheckFailed
    case keychainError
    case sessionExpired
    case unknown(String)
    
    var errorDescription: String? {
        switch self {
        case .firebaseUserNotFound:
            return "No account found with this email. Please sign up first."
        case .shopifyCustomerNotFound:
            return "Account found but Shopify profile is missing. Please contact support."
        case .invalidEmail:
            return "Please enter a valid email address."
        case .invalidCredentials:
            return "Invalid email or password. Please try again."
        case .accountDisabled:
            return "This account has been disabled. Please contact support."
        case .networkError(let message):
            return message
        case .tooManyAttempts:
            return "Too many failed attempts. Please try again later."
        case .emailAlreadyInUse:
            return "This email is already registered. Please login instead."
        case .weakPassword:
            return "Password is too weak. Please use a stronger password."
        case .missingEmail:
            return "Please enter your email address."
        case .operationNotAllowed:
            return "This operation is not allowed. Please contact support."
        case .requiresRecentLogin:
            return "Please login again to continue."
        case .providerAlreadyLinked:
            return "This account is already linked to another provider."
        case .credentialAlreadyInUse:
            return "These credentials are already in use."
        case .internalError:
            return "An internal error occurred. Please try again later."
        case .appNotAuthorized:
            return "App not authorized. Please contact support."
        case .appVerificationDisabled:
            return "App verification is disabled."
        case .captchaCheckFailed:
            return "Captcha verification failed. Please try again."
        case .keychainError:
            return "A security error occurred. Please try again."
        case .sessionExpired:
            return "Your session has expired. Please login again."
        case .unknown(let message):
            return "An error occurred: \(message)"
        }
    }
}
