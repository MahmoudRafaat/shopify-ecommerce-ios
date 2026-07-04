//
//  SettingsRepositoryProtocol.swift
//  shopify-ecommerce-ios
//
//  Created by Mahmoud Raafat Mustafa on 04/07/2026.
//


//
//  SettingsRepository.swift
//  shopify-ecommerce-ios
//
//  Created by Mahmoud Raafat Mustafa on 04/07/2026.
//

import Foundation
import FirebaseAuth

protocol SettingsRepositoryProtocol {
    func getCurrentUser() -> User?
    func logout() throws
    func isLoggedIn() -> Bool
}

class SettingsRepository: SettingsRepositoryProtocol {
    
    private let auth: Auth
    private let userDefaults: UserDefaults
    
    init(
        auth: Auth = Auth.auth(),
        userDefaults: UserDefaults = .standard
    ) {
        self.auth = auth
        self.userDefaults = userDefaults
    }
    
    func getCurrentUser() -> User? {
        return auth.currentUser
    }
    
    func isLoggedIn() -> Bool {
        return auth.currentUser != nil && userDefaults.bool(forKey: AppConstants.isLoggedIn)
    }
    
    func logout() throws {
        do {
            try auth.signOut()
            // Clear all user defaults
            userDefaults.removeObject(forKey: AppConstants.isLoggedIn)
            userDefaults.removeObject(forKey: AppConstants.customerId)
            userDefaults.removeObject(forKey: "firebase_user_id")
            userDefaults.removeObject(forKey: "shopify_customer_id")
            userDefaults.removeObject(forKey: "user_email")
            userDefaults.synchronize()
        } catch {
            throw SettingsError.logoutFailed(error.localizedDescription)
        }
    }
}

enum SettingsError: LocalizedError {
    case logoutFailed(String)
    case userNotAuthenticated
    
    var errorDescription: String? {
        switch self {
        case .logoutFailed(let message):
            return "Logout failed: \(message)"
        case .userNotAuthenticated:
            return "User not authenticated"
        }
    }
}