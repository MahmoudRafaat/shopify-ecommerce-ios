//
//  AuthRouter.swift
//  shopify-ecommerce-ios
//
//  Created by Ehab Salah on 01/07/2026.
//

import Foundation
import Alamofire

enum NetworkAuthHandler {
    case createCustomer(requestBody: CustomerRequest)
    case searchCustomer(email: String)

    private var fullURL: String {
        switch self {
        case .createCustomer:
            return NetworkConstants.BaseURL + AuthEndopints.createCustomer
        case .searchCustomer(let email):
            let encodedEmail = email.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? email
            return NetworkConstants.BaseURL + AuthEndopints.searchCustomer + "?query=email:\(encodedEmail)"
        }
    }
    
    private var method: HTTPMethod {
        switch self {
        case .createCustomer:
            return .post
        case .searchCustomer:
            return .get
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
        case .searchCustomer:
            task = AF.request(
                fullURL,
                method: method,
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
