//
//  Message.swift
//  shopify-ecommerce-ios
//
//  Created by Mahmoud Raafat Mustafa on 07/07/2026.
//

import Foundation
import SwiftUI

struct Message: Identifiable, Equatable {
    let id = UUID()
    let content: String
    let isUser: Bool
    let timestamp: Date
    var attachments: [MessageAttachment] = []
    
    static func == (lhs: Message, rhs: Message) -> Bool {
        lhs.id == rhs.id
    }
}

struct MessageAttachment: Identifiable {
    let id = UUID()
    let type: AttachmentType
    let data: Data
    let thumbnail: Data?
    let fileName: String?
    
    enum AttachmentType {
        case image
        case product
    }
}

struct ProductContext {
    let product: Product
    let relevanceScore: Float
    let matchingKeywords: [String]
}

struct AIResponse {
    let text: String
    let suggestedProducts: [Product]
    let suggestedCategories: [Category]
}
