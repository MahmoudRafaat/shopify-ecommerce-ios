//
//  ShopifyErrorModel.swift
//  shopify-ecommerce-ios
//
//  Created by Ehab Salah on 01/07/2026.
//

import Foundation

import Foundation

struct ShopifyErrorResponse: Codable, Error {
    let errors: [String: [String]]
    
    var fullErrorMessage: String {
        var errorMessages: [String] = []
        
        for (field, messages) in errors {
            let capitalizedField = field.capitalized
            
            let combinedMessages = messages.joined(separator: ", ")
            
            errorMessages.append("\(capitalizedField) \(combinedMessages)")
        }
        
        if errorMessages.isEmpty {
            return "Registration data is invalid or already taken."
        }
        return errorMessages.joined(separator: " | ")
    }
}
