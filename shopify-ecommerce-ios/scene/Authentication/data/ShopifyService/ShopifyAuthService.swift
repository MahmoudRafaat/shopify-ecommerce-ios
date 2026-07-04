//
//  ShopifyAuthService.swift
//  shopify-ecommerce-ios
//
//  Created by Ehab Salah on 30/06/2026.
//

import Foundation
import Alamofire

protocol ShopifyAuthServiceProtocol {
    func createCustomer(input: CustomerInput) async throws -> CustomerOutput
    func searchCustomer(email: String) async throws -> CustomerOutput
}

class ShopifyAuthService: ShopifyAuthServiceProtocol {

    func createCustomer(input: CustomerInput) async throws -> CustomerOutput {
        let response: CustomerResponse = try await NetworkService.request(
            endpoint: AuthEndpoint.createCustomer(request: CustomerRequest(customer: input))
        )
        return response.customer
    }
    
    func searchCustomer(email: String) async throws -> CustomerOutput {
        let response: CustomerSearchResponse = try await NetworkService.request(
            endpoint: AuthEndpoint.searchCustomer(email: email)
        )
        
        guard let customer = response.customers.first else {
            throw LoginError.firebaseUserNotFound
        }
        
        return customer
    }
}
