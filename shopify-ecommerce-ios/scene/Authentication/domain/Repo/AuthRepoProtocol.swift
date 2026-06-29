//
//  AuthRepoProtocol.swift
//  shopify-ecommerce-ios
//
//  Created by Ehab Salah on 29/06/2026.
//

import Foundation
import FirebaseAuth
protocol AuthRepoProtocol {
    func register(email: String, password: String) async throws -> User?
}
