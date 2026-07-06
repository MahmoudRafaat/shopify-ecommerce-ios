
//
//  GetOrdersUseCaseProtocol.swift
//  shopify-ecommerce-ios
//
//  Created by Mahmoud Raafat Mustafa on 06/07/2026.
//



import Foundation

protocol GetOrdersUseCaseProtocol {
    func execute(customerId: Int) async throws -> [OrderDisplayModel]
}

class OrdersUseCase: GetOrdersUseCaseProtocol {
    
    private let repository: OrderRepositoryProtocol
    
    init(repository: OrderRepositoryProtocol = OrderRepository()) {
        self.repository = repository
    }
    
    func execute(customerId: Int) async throws -> [OrderDisplayModel] {
        return try await repository.getOrders(customerId: customerId)
    }
}
