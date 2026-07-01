//
//  NetworkManager.swift
//  shopify-ecommerce-ios
//
//  Created by Ehab Salah on 01/07/2026.
//

import Foundation
import Alamofire

class NetworkManager {
    static let shared = NetworkManager()
    private init() {}
    
    
    func setupAlamofireRequest<Req: Encodable, Res: Decodable>(
        endpoint: String,
        method: HTTPMethod = .get,
        parameters: Req? = nil,
        headers: HTTPHeaders? = nil
    ) async throws -> Res {
        
        var finalHeaders: HTTPHeaders = [
            "Content-Type": "application/json",
            "X-Shopify-Access-Token": NetworkConstants.AdminToken
        ]
        
        if let additionalHeaders = headers {
            for header in additionalHeaders {
                finalHeaders.update(header)
            }
        }
        
        let task = AF.request(
            NetworkConstants.BaseURL + endpoint,
            method: method,
            parameters: parameters,
            encoder: JSONParameterEncoder.default,
            headers: finalHeaders
        )
            .validate()
        
        let dataResponse = await task.serializingData().response
        
        if let data = dataResponse.data {
            let prettyString = JsonHelper.prettyJSON(data)
            print("Response JSON for [\(endpoint)]: \(prettyString)")
        }
        
        try dataResponse.validateAndHandlError()
        
        let response = try await task.serializingDecodable(Res.self).value
        return response
    }
}
