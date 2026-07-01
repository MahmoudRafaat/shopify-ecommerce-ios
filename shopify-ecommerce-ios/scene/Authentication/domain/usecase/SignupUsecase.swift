//
//  SignupUsecase.swift
//  shopify-ecommerce-ios
//
//  Created by Ehab Salah on 29/06/2026.
//

import Foundation
import FirebaseAuth

class SignupUseCase {
    private let repository: AuthRepoProtocol
    
    init(repository: AuthRepoProtocol = AuthRepoImp()) {
        self.repository = repository
    }
    
    func execute(email: String, password: String) async throws {
        var firebaseUser: User?
        do {
            firebaseUser = try await repository.registerByFireBase(email: email, password: password)
        }
        catch let error as NSError {
            
            if AuthErrorCode(rawValue: error.code) == .emailAlreadyInUse {
                print("Email already exists")
                try await createShopifyUser(email: email)
                return
            }
            throw error
        }
        
        try await createShopifyUser(email: (firebaseUser?.email)!)
    }
    
    func createShopifyUser (email:String) async throws {
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
            email: email,
            phone: "+201144840790",
            addresses: [addressInput]
        )
        
        _ = try await repository.createCustomerInShopify(customerInput: customerInput)
    }
}
