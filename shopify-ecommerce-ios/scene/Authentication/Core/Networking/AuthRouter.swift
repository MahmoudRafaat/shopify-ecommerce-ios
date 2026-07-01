//
//  AuthRouter.swift
//  shopify-ecommerce-ios
//
//  Created by Ehab Salah on 01/07/2026.
//

import Foundation
import Alamofire

enum AuthRouter {
    case createCustomer(requestBody: CustomerRequest)

    private var fullURL: String {
        switch self {
        case .createCustomer:
            return NetworkConstants.BaseURL + NetworkConstants.CreateCustomerEndpoint
        }
    }
    
    private var method: HTTPMethod {
        switch self {
        case .createCustomer:
            return .post
        }
    }
    
    func execute<Res: Decodable>() async throws -> Res {
        
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "X-Shopify-Access-Token": NetworkConstants.AdminToken
        ]
        
        let task: DataRequest
        
        switch self {
        case .createCustomer(let requestBody):
            task = AF.request(
                fullURL,
                method: method,
                parameters: requestBody,
                encoder: JSONParameterEncoder.default,
                headers: headers
            ).validate()
        }
        
        let dataResponse = await task.serializingData().response
        
        if let data = dataResponse.data {
            let prettyString = JsonHelper.prettyJSON(data)
            print("Response JSON: \(prettyString)")
        }
        
        try dataResponse.validateAndHandlError()

        let response = try await task.serializingDecodable(Res.self).value
        return response
    }
}
