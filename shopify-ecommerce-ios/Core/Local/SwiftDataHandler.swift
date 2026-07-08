//
//  SwiftDataHandler.swift
//  shopify-ecommerce-ios
//
//  Created by Ehab Salah on 07/07/2026.
//

import Foundation
import SwiftData

@MainActor
final class SwiftDataHandler {
    static let shared = SwiftDataHandler()
    
    let sharedModelContainer: ModelContainer = {
        let schema = Schema([
            FavoriteProduct.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        
        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            print("Could not create ModelContainer: \(error)")
            let fallbackConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
            return try! ModelContainer(for: schema, configurations: [fallbackConfiguration])
        }
    }()
    
    private init() {}
}
