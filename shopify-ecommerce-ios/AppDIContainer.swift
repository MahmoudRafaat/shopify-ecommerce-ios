//
//  AppDIContainer.swift
//  shopify-ecommerce-ios
//
//  Created by albaraa alsayed on 15/01/1448 AH.
//

import Foundation

final class AppDIContainer {
    let shopifyHostname = SeacretConstants.hostname
    let shopifyAPIKey = SeacretConstants.apiKey
    let shopifyPassword = SeacretConstants.password
    
    var shopifyBaseURL: String {
        return "https://\(shopifyAPIKey):\(shopifyPassword)@\(shopifyHostname)/admin/api/2026-01/"
    }
}
