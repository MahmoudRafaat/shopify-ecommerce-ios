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
        let firebaseUser = try await repository.registerByFireBase(email: email, password: password)
        let addressInput = AddressInput(
            address1: "123 Oak St",
            city: "Ottawa",
            province: "ON",
            phone: "555-1212",
            zip: "123 ABC",
            country: "CA"
        )
        let customerInput = CustomerInput(
            firstName: "Ehab",
            lastName: "Salah",
            email: (firebaseUser?.email)!,
            phone: "+201144840791",
            addresses: [addressInput]
        )
        
        _ = try await repository.createCustomerInShopify(customerInput: customerInput)
    }
}
