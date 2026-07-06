//
//  OrderRepositoryProtocol.swift
//  shopify-ecommerce-ios
//
//  Created by Mahmoud Raafat Mustafa on 06/07/2026.
//



import Foundation

protocol OrderRepositoryProtocol {
    func getOrders(customerId: Int) async throws -> [OrderDisplayModel]
}
