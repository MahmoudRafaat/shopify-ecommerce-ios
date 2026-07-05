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
    
    @AppStorage(AppConstants.hasSeenOnboarding) private var hasSeenOnboarding = false
    @AppStorage(AppConstants.isLoggedIn) private var isLoggedIn = false
    
    var body: some Scene {
        WindowGroup {
            //            if !hasSeenOnboarding {
            //                OnboardingScreen()
            //            } else if isLoggedIn {
            //                TabBarView()
            //            } else {
            //                NavigationStack {
            //                    SignupView(viewmodel: SignupViewModel())
            //                }
            //            }
            CheckoutView(lineItems: [
                DraftLineItemRequest(variantId: 46128795517064, quantity: 1),
//                DraftLineItemRequest(variantId: 8955349303432, quantity: 2)
            ])
        }
        .modelContainer(sharedModelContainer)
    }
}
