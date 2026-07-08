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
    func loginUser(withEmail email: String, password: String) async throws -> User?
    func loginWithGoogle(credential: AuthCredential) async throws -> User?
}

class FirebaseAuthService: AuthServiceProtocol {
    
    func registerUser(withEmail email: String, password: String) async throws -> User? {
        let authResult = try await Auth.auth().createUser(withEmail: email, password: password)
        return authResult.user
    }
    
    func loginUser(withEmail email: String, password: String) async throws -> User? {
        let authResult = try await Auth.auth().signIn(withEmail: email, password: password)
        return authResult.user
    }
    
    func loginWithGoogle(credential: AuthCredential) async throws -> User? {
        let authResult = try await Auth.auth().signIn(with: credential)
        return authResult.user
    }
}
