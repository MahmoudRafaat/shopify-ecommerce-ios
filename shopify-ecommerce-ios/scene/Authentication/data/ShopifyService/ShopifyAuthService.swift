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
    func searchCustomer(email: String) async throws -> CustomerOutput
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
            let prettyString = JsonHelper.prettyJSON(data)
            print("Response JSON: \(prettyString)")
        }
        
        try dataResponse.validateAndHandlError()
        
        let response = try await task.serializingDecodable(CustomerResponse.self).value
        return response.customer
    }
    
    func searchCustomer(email: String) async throws -> CustomerOutput {
        let encodedEmail = email.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? email
        let searchEndpoint = "/customers/search.json?query=email:\(encodedEmail)"
        
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "X-Shopify-Access-Token": NetworkConstants.AdminToken
        ]
        
        let task = AF.request(
            NetworkConstants.BaseURL + searchEndpoint,
            method: .get,
            headers: headers
        )
            .validate()
        
        let dataResponse = await task.serializingData().response
        if let data = dataResponse.data {
            let prettyString = JsonHelper.prettyJSON(data)
            print("Search Response JSON: \(prettyString)")
        }
        
        try dataResponse.validateAndHandlError()
        
        let response = try await task.serializingDecodable(CustomerSearchResponse.self).value
        
        guard let customer = response.customers.first else {
            throw LoginError.firebaseUserNotFound
        }
        
        return customer
    }
}
