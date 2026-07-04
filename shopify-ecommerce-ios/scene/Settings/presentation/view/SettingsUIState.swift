//
//  SettingsUIState.swift
//  shopify-ecommerce-ios
//
//  Created by Mahmoud Raafat Mustafa on 04/07/2026.
//




import Foundation

struct SettingsUIState {
    var userEmail: String = ""
    var userName: String = ""
    var isLoggedIn: Bool = false
    var isGuestMode: Bool = false
    
    var pushNotificationsEnabled: Bool = true
    var darkThemeEnabled: Bool = false
    
    var isLoading: Bool = false
    var showHelpAlert: Bool = false
    var showLogoutConfirmation: Bool = false
    var errorMessage: String? = nil
    
    var helpText: String = """
    Need help? Here are some resources:
    
    📖 Check our FAQ section
    📧 Contact support@stylish.com
    📞 Call us at 1-800-STYLISH
    💬 Live chat available 24/7
    """
}
