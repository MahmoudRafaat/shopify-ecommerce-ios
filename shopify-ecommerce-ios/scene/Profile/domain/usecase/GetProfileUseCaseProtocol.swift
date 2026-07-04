//
//  ProfileUseCase.swift
//  shopify-ecommerce-ios
//
//  Created by Mahmoud Raafat Mustafa on 04/07/2026.
//

import Foundation

protocol GetProfileUseCaseProtocol {
    func execute(customerId: Int) async throws -> ProfileDisplayModel
}

protocol UpdateProfileUseCaseProtocol {
    func updateName(customerId: Int, firstName: String, lastName: String) async throws
    func updateAddress(customerId: Int, address: ProfileAddress) async throws -> ProfileAddress
    func updatePaymentDetails(customerId: Int, paymentDetails: PaymentDetails) async throws
}

class ProfileUseCase: GetProfileUseCaseProtocol, UpdateProfileUseCaseProtocol {
    
    private let repository: ProfileRepositoryProtocol
    
    init(repository: ProfileRepositoryProtocol = ProfileRepository()) {
        self.repository = repository
    }
    
    func execute(customerId: Int) async throws -> ProfileDisplayModel {
        return try await repository.getProfile(customerId: customerId)
    }
    
    func updateName(customerId: Int, firstName: String, lastName: String) async throws {
        try await repository.updateName(customerId: customerId, firstName: firstName, lastName: lastName)
    }
    
    func updateAddress(customerId: Int, address: ProfileAddress) async throws -> ProfileAddress {
        return try await repository.updateAddress(customerId: customerId, address: address)
    }
    
    func updatePaymentDetails(customerId: Int, paymentDetails: PaymentDetails) async throws {
        try await repository.updatePaymentDetails(customerId: customerId, paymentDetails: paymentDetails)
    }
}
