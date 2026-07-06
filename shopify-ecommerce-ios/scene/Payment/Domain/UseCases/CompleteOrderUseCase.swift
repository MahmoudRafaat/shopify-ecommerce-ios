//
//  CompleteOrderUseCase.swift
//  shopify-ecommerce-ios
//
//  Created by albaraa alsayed on 19/01/1448 AH.
//

import Foundation

protocol CompleteOrderUseCase {
    func execute(id: Int, paymentPending: Bool) async throws
}

class CompleteOrderUseCaseImp: CompleteOrderUseCase {
    private let repository: PaymentRepo
    
    init(repository: PaymentRepo) {
        self.repository = repository
    }
    
    func execute(id: Int, paymentPending: Bool) async throws {
        try await repository.completeOrder(id: id, paymentPending: paymentPending)
    }
}
