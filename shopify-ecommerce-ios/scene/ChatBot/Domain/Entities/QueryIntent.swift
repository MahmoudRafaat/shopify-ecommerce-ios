//
//  QueryIntent.swift
//  shopify-ecommerce-ios
//
//  Created by Mahmoud Raafat Mustafa on 07/07/2026.
//

import Foundation

enum QueryIntent {
    case general
    case productSearch
    case comparison
    case overallSuggestions
}

struct QueryIntentClassifier {

    private static let productKeywords: Set<String> = [
        "recommend", "suggest", "suggestion", "looking for", "show me",
        "buy", "price", "cost", "cheap", "expensive", "budget",
        "compare", "comparison", "vs", "versus", "better",
        "product", "item", "shoe", "shirt", "jacket", "bag",
        "available", "in stock", "size", "color", "brand"
    ]

    

    static func classify(_ text: String) -> QueryIntent {
        let lower = text.lowercased()

        if lower.contains("compare") || lower.contains(" vs ") || lower.contains("versus") {
            return .comparison
        }

        if lower.contains("popular") || lower.contains("trending") || lower.contains("best sellers")
            || lower.contains("overall suggestion") {
            return .overallSuggestions
        }

        for keyword in productKeywords {
            if lower.contains(keyword) {
                return .productSearch
            }
        }

        return .general
    }

    
    static func extractSearchQuery(from text: String) -> String {
        let fillers: Set<String> = [
            "i", "am", "im", "looking", "for", "want", "need", "show", "me",
            "a", "an", "the", "please", "can", "you", "recommend", "suggest",
            "some", "any", "good", "cheap", "under", "over"
        ]
        let words = text
            .lowercased()
            .components(separatedBy: .whitespacesAndNewlines)
            .filter { !$0.isEmpty && !fillers.contains($0) }
        return words.joined(separator: " ")
    }
}
