//
//  shopify_ecommerce_iosApp.swift
//  shopify-ecommerce-ios
//
//  Created by Mahmoud Raafat Mustafa on 27/06/2026.
//

import SwiftUI
import SwiftData
import GoogleSignIn

@main
struct shopify_ecommerce_iosApp: App {
    
    // Checking internet Connction Variable
    @State private var networkMonitor = NetworkMonitor()
    @State private var currencyService = CurrencyService.shared
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    @AppStorage(AppConstants.hasSeenOnboarding) private var hasSeenOnboarding = false
    @AppStorage(AppConstants.isLoggedIn) private var isLoggedIn = false
    @AppStorage(AppConstants.isGuestMode) private var isGuestMode = false
    @AppStorage("isDarkMode") private var isDarkMode = false
    
    var body: some Scene {
        WindowGroup {
            AnimatedSplashScreen {
                if !hasSeenOnboarding {
                    OnboardingScreen()
                } else if isLoggedIn || isGuestMode {
                    TabBarView()
                } else {
                    NavigationStack {
                        SignupView(viewmodel: AuthFactory.makeSignupViewModel())
                    }
                }
            }
            .onOpenURL { url in
                GIDSignIn.sharedInstance.handle(url)
            }
            .task {
                await currencyService.refreshRatesIfNeeded()
            }
            .modelContainer(SwiftDataHandler.shared.sharedModelContainer)
            .environment(networkMonitor)
            .environment(currencyService)
            .preferredColorScheme(isDarkMode ? .dark : nil)
        }
    }
}
