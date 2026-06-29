//
//  AuthRepo.swift
//  shopify-ecommerce-ios
//
//  Created by Ehab Salah on 29/06/2026.
//

import Foundation
import FirebaseAuth
class AuthRepoImp: AuthRepoProtocol {
    private let authService: AuthServiceProtocol
    
    init(authService: AuthServiceProtocol = FirebaseAuthService()) {
        self.authService = authService
    }
    
    func register(email: String, password: String) async throws -> User? {
        return try await authService.registerUser(withEmail: email, password: password)
    }
}
