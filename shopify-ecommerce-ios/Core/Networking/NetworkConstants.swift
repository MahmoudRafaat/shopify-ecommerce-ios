//
//  NetworkConstants.swift
//  shopify-ecommerce-ios
//
//  Created by Ehab Salah on 30/06/2026.
//

import Foundation


struct NetworkConstants {
    static let baseURL = "https://mad46-ios-team4.myshopify.com/admin/api/2026-01"
    
    static func getAdminToken() throws -> String {
        guard let token = Bundle.main.object(forInfoDictionaryKey: "ShopifyAdminToken") as? String else {
            throw NetworkError.missingAdminToken
        }
        return token
    }
    
    static func getApiKey() throws -> String {
        guard let key = Bundle.main.object(forInfoDictionaryKey: "ShopifyApiKey") as? String else {
            throw NetworkError.missingApiKey
        }
        return key
    }
}
