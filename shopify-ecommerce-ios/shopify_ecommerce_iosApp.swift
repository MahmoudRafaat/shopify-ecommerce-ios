//
//  shopify_ecommerce_iosApp.swift
//  shopify-ecommerce-ios
//
//  Created by Mahmoud Raafat Mustafa on 27/06/2026.
//

import SwiftUI
import SwiftData

@main
struct shopify_ecommerce_iosApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            LoginView(viewmodel: LoginViewModel())
        }
        .modelContainer(sharedModelContainer)
    }
}
