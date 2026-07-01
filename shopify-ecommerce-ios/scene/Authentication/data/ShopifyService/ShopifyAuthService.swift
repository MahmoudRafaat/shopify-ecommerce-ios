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
        let response: CustomerResponse = try await NetworkAuthHandler.createCustomer(requestBody: CustomerRequest(customer: input)).execute()
        return response.customer
    }
    
    func searchCustomer(email: String) async throws -> CustomerOutput {
        let response: CustomerSearchResponse = try await NetworkAuthHandler.searchCustomer(email: email).execute()
        
        guard let customer = response.customers.first else {
            throw LoginError.firebaseUserNotFound
        }
        
        return customer
    }
}
