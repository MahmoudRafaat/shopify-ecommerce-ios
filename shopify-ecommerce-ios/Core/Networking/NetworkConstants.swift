//
//  NetworkConstants.swift
//  shopify-ecommerce-ios
//
//  Created by Ehab Salah on 30/06/2026.
//

struct Constants {
    
    static var baseURL: String {
        return "https://\(SecretConstants.apiKey):\(SecretConstants.password)@\(SecretConstants.hostname)/admin/api/2026-01/"
    }
    
    static let adminToken = SecretConstants.password
    static let apiKey = SecretConstants.apiKey
}
