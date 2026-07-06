//
//  OrderRepository.swift
//  shopify-ecommerce-ios
//
//  Created by Mahmoud Raafat Mustafa on 06/07/2026.
//



import Foundation

class OrderRepository: OrderRepositoryProtocol {
    
    private let networkService: NetworkService.Type
    
    init(networkService: NetworkService.Type = NetworkService.self) {
        self.networkService = networkService
    }
    
    func getOrders(customerId: Int) async throws -> [OrderDisplayModel] {
        let endpoint = OrdersEndpoint.getOrders(customerId: customerId)
        let response: OrdersResponseDTO = try await networkService.request(endpoint: endpoint)
        
        return response.orders.map { OrderDisplayModel(from: $0) }
    }
}
