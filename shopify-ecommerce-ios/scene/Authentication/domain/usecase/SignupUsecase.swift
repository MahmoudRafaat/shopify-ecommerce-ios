//
//  SignupUsecase.swift
//  shopify-ecommerce-ios
//
//  Created by Ehab Salah on 29/06/2026.
//

import Foundation

class SignupUseCase {
    private let repository: AuthRepoProtocol
    
    init(repository: AuthRepoProtocol = AuthRepoImp()) {
        self.repository = repository
    }
    
    func execute(email: String, password: String) async throws {
        _ = try await repository.register(email: email, password: password)
    }
}
