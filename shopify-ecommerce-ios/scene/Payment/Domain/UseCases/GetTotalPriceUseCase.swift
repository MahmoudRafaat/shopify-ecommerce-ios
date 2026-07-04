//
//  GetTotalPriceUseCase.swift
//  shopify-ecommerce-ios
//
//  Created by albaraa alsayed on 19/01/1448 AH.
//

import Foundation

protocol GetTotalPriceUseCase {
    func execute() async throws -> String
}

class GetTotalPriceUseCaseImp: GetTotalPriceUseCase {
    private let repository: PaymentRepo
    
    init(repository: PaymentRepo) {
        self.repository = repository
    }
    
    func execute() async throws -> String {
        return try await repository.getTotalPrice().total
    }
}
