//
//  GoogleAuthUseCase.swift
//  shopify-ecommerce-ios
//
//  Created by Antigravity on 08/07/2026.
//

import Foundation
import FirebaseAuth

class GoogleAuthUseCase {
    private let repository: AuthRepoProtocol
    
    init(repository: AuthRepoProtocol = AuthRepoImp()) {
        self.repository = repository
    }
    
    func execute(credential: AuthCredential, email: String, phone: String?) async throws -> LoginResult {
        var firebaseUser: User?
        var shopifyCustomer: CustomerOutput?
        
        do {
            firebaseUser = try await repository.loginWithGoogle(credential: credential)
        } catch let error as NSError {
            if let authError = AuthErrorCode(rawValue: error.code) {
                throw mapFirebaseError(authError)
            } else {
                throw LoginError.unknown(error.localizedDescription)
            }
        }
        
        guard let user = firebaseUser else {
            throw LoginError.firebaseUserNotFound
        }
        
        do {
            shopifyCustomer = try await repository.searchCustomerInShopify(email: email)
        } catch LoginError.firebaseUserNotFound {
            // Customer not found in Shopify. Check if we have a phone number to create one.
            guard let validPhone = phone, !validPhone.isEmpty else {
                throw LoginError.phoneRequiredForGoogleAuth
            }
            
            let input = CustomerInput(
                email: email,
                phone: "+2" + validPhone
            )
            do {
                shopifyCustomer = try await repository.createCustomerInShopify(customerInput: input)
            } catch {
                throw LoginError.shopifyCustomerNotFound
            }
        } catch {
            throw LoginError.shopifyCustomerNotFound
        }
        
        guard let customer = shopifyCustomer else {
            throw LoginError.shopifyCustomerNotFound
        }
        
        if let customerId = customer.id {
            UserDefaults.standard.set(customerId, forKey: AppConstants.customerId)
        }
        
        return LoginResult(
            firebaseUser: user,
            shopifyCustomer: customer
        )
    }
    
    private func mapFirebaseError(_ error: AuthErrorCode) -> LoginError {
        switch error {
        case .invalidEmail:
            return .invalidEmail
        case .wrongPassword:
            return .invalidCredentials
        case .userNotFound:
            return .firebaseUserNotFound
        case .userDisabled:
            return .accountDisabled
        case .tooManyRequests:
            return .tooManyAttempts
        case .networkError:
            return .networkError("Please check your internet connection and try again.")
        case .emailAlreadyInUse:
            return .emailAlreadyInUse
        case .weakPassword:
            return .weakPassword
        case .missingEmail:
            return .missingEmail
        case .operationNotAllowed:
            return .operationNotAllowed
        case .requiresRecentLogin:
            return .requiresRecentLogin
        case .providerAlreadyLinked:
            return .providerAlreadyLinked
        case .credentialAlreadyInUse:
            return .credentialAlreadyInUse
        case .invalidCredential:
            return .invalidCredentials
        case .internalError:
            return .internalError
        case .appNotAuthorized:
            return .appNotAuthorized
     
        case .captchaCheckFailed:
            return .captchaCheckFailed
        case .keychainError:
            return .keychainError
        case .sessionExpired:
            return .sessionExpired
        case .webNetworkRequestFailed:
            return .networkError("Network request failed. Please try again.")
        case .webInternalError:
            return .internalError
        default:
            return .unknown(error.localizedDescription)
        }
    }
}
