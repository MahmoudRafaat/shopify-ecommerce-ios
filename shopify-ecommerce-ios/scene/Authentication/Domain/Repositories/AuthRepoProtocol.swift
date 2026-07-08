//
//  AuthRepoProtocol.swift
//  shopify-ecommerce-ios
//
//  Created by Ehab Salah on 29/06/2026.
//

import Foundation
import FirebaseAuth
protocol AuthRepoProtocol {
    func registerByFireBase(email: String, password: String) async throws -> User?
    func createCustomerInShopify(customerInput: CustomerInput) async throws -> Customer
    func loginByFireBase(email: String, password: String) async throws -> User?
    func loginWithGoogle(credential: AuthCredential) async throws -> User?
    func searchCustomerInShopify(email: String) async throws -> Customer
}
