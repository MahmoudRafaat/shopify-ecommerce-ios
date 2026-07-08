//
//  AuthRepoImp.swift
//  shopify-ecommerce-ios
//
//  Created by Ehab Salah on 29/06/2026.
//

import Foundation
import FirebaseAuth


class AuthRepoImp: AuthRepoProtocol {
    
    private let authService: AuthServiceProtocol
    private let shopifyService: ShopifyAuthServiceProtocol
    
    init(authService: AuthServiceProtocol = FirebaseAuthService(),
         shopifyService: ShopifyAuthServiceProtocol = ShopifyAuthService()) {
        self.authService = authService
        self.shopifyService = shopifyService
    }
    
    func registerByFireBase(email: String, password: String) async throws -> User? {
        return try await authService.registerUser(withEmail: email, password: password)
    }
    
    func createCustomerInShopify(customerInput: CustomerInput) async throws -> Customer {
        let output = try await shopifyService.createCustomer(input: customerInput)
        return CustomerMapper.map(from: output)
    }
    
    func loginByFireBase(email: String, password: String) async throws -> User? {
        return try await authService.loginUser(withEmail: email, password: password)
    }
    
    func loginWithGoogle(credential: AuthCredential) async throws -> User? {
        return try await authService.loginWithGoogle(credential: credential)
    }
    
    func searchCustomerInShopify(email: String) async throws -> Customer {
        let output = try await shopifyService.searchCustomer(email: email)
        return CustomerMapper.map(from: output)
    }
}
