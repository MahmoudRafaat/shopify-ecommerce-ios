//
//  FirebaseAuthService.swift
//  shopify-ecommerce-ios
//
//  Created by Ehab Salah on 29/06/2026.
//

import Foundation
import FirebaseAuth


protocol AuthServiceProtocol {
    func registerUser(withEmail email: String, password: String) async throws -> User?
}

class FirebaseAuthService: AuthServiceProtocol {
    
    func registerUser(withEmail email: String, password: String) async throws -> User? {
        let authResult = try await Auth.auth().createUser(withEmail: email, password: password)
        return authResult.user
    }
}
