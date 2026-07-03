//
//  AppDelegate.swift
//  shopify-ecommerce-ios
//
//  Created by Ehab Salah on 29/06/2026.
//

import Foundation
import SwiftUI
import FirebaseCore
class AppDelegate: NSObject, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        print(
            "customer id = " + (
                UserDefaults.standard.string(forKey: AppConstants.customerId) ?? "No Cutomer Id"
            )
        )
        FirebaseApp.configure()
        return true
    }
}
