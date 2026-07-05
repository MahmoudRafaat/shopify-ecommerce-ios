//
//  GetPaymentCard.swift
//  shopify-ecommerce-ios
//
//  Created by albaraa alsayed on 20/01/1448 AH.
//

import Foundation

protocol GetPaymentCardUseCase {
    func execute() async throws -> [PaymentCardNumber]
}

class GetPaymentCardUseCaseImp: GetPaymentCardUseCase {
    let repository: PaymentRepo
    init(repository: PaymentRepo) {
        self.repository = repository
    }
    func execute() async throws -> [PaymentCardNumber] {
        return try await repository.getPaymentCard()
    }
}
