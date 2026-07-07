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
    
    // Checking internet Connction Variable
    @State private var networkMonitor = NetworkMonitor()
    @State private var currencyService = CurrencyService.shared
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    @AppStorage(AppConstants.hasSeenOnboarding) private var hasSeenOnboarding = false
    @AppStorage(AppConstants.isLoggedIn) private var isLoggedIn = false
    
    var body: some Scene {
        WindowGroup {
            AnimatedSplashScreen {
                if !hasSeenOnboarding {
                    OnboardingScreen()
                } else if isLoggedIn {
                    TabBarView()
                } else {
                    NavigationStack {
                        SignupView(viewmodel: SignupViewModel())
                    }
                }
            }
            .task {
                await currencyService.refreshRatesIfNeeded()
            }
        }
        .modelContainer(SwiftDataHandler.shared.sharedModelContainer)
        .environment(networkMonitor)
        .environment(currencyService)
    }
}
