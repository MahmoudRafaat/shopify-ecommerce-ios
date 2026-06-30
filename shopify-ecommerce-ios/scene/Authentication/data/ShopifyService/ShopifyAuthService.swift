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
        
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "X-Shopify-Access-Token": NetworkConstants.AdminToken
        ]
        
        let requestBody = CustomerRequest(customer: input)
        
        let task = AF.request(
            NetworkConstants.BaseURL + NetworkConstants.CreateCustomerEndpoint,
            method: .post,
            parameters: requestBody,
            encoder: JSONParameterEncoder.default,
            headers: headers
        )
            .validate()
        
        let dataResponse = await task.serializingData().response
        if let data = dataResponse.data {
            if let jsonString = String(data: data, encoding: .utf8) {
                print(jsonString)
            }
        }
        
        let response = try await task.serializingDecodable(CustomerResponse.self).value
        return response.customer
    }
}
