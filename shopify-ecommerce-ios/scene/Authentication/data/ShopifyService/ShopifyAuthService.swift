//
//  ShopifyService.swift
//  shopify-ecommerce-ios
//
//  Created by Ehab Salah on 30/06/2026.
//
//
//  ShopifyService.swift
//  shopify-ecommerce-ios
//
//  Created by Ehab Salah on 30/06/2026.
//

import Foundation
import Alamofire

protocol ShopifyAuthServiceProtocol {
    func createCustomer(input: CustomerInput) async throws -> CustomerOutput
}

class ShopifyAuthService: ShopifyAuthServiceProtocol {
    
    func createCustomer(input: CustomerInput) async throws -> CustomerOutput {
        
        let requestBody = CustomerRequest(customer: input)
        
        let response: CustomerResponse = try await NetworkManager.shared.setupAlamofireRequest(
            endpoint: NetworkConstants.CreateCustomerEndpoint,
            method: .post,
            parameters: requestBody,
        )
        
        return response.customer
    }
}
