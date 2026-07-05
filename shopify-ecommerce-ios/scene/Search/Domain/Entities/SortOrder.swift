//
//  SortOrder.swift
//  shopify-ecommerce-ios
//
//  Created by albaraa alsayed on 20/01/1448 AH.
//

import Foundation

enum SortOrder: String, CaseIterable {
    case newest = "created_at desc"
    case oldest = "created_at asc"
    
    var displayName: String {
        switch self {
        case .newest:
            return "Newest First"
        case .oldest:
            return "Oldest First"
        }
    }
}
