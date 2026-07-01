//
//  NetworkConstants.swift
//  shopify-ecommerce-ios
//
//  Created by Ehab Salah on 30/06/2026.
//

import Foundation

class NetworkConstants {
    static let BaseURL = "https://mad46-ios-team4.myshopify.com/admin/api/2026-01"
    static let CreateCustomerEndpoint = "/customers.json"
    
    static let AdminToken: String = {
        guard let token = Bundle.main.object(forInfoDictionaryKey: "ShopifyAdminToken") as? String else {
            fatalError("ShopifyAdminToken not found in Info.plist")
        }
        return token
    }()
    
    static let ApiKey: String = {
        guard let key = Bundle.main.object(forInfoDictionaryKey: "ShopifyApiKey") as? String else {
            fatalError("ShopifyApiKey not found in Info.plist")
        }
        return key
    }()
}
