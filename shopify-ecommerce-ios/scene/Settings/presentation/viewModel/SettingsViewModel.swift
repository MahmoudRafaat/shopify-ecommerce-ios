//
//  SettingsViewModel.swift
//  shopify-ecommerce-ios
//
//  Created by Mahmoud Raafat Mustafa on 04/07/2026.
//

import Foundation
import Observation
import FirebaseAuth

@Observable
class SettingsViewModel {
    
    private let getUserUseCase: GetUserProfileUseCaseProtocol
    private let logoutUseCase: LogoutUseCaseProtocol
    private let checkLoginUseCase: CheckLoginStatusUseCaseProtocol
    
    var uiState = SettingsUIState()
    
    init(
        getUserUseCase: GetUserProfileUseCaseProtocol = SettingsUseCase(),
        logoutUseCase: LogoutUseCaseProtocol = SettingsUseCase(),
        checkLoginUseCase: CheckLoginStatusUseCaseProtocol = SettingsUseCase()
    ) {
        self.getUserUseCase = getUserUseCase
        self.logoutUseCase = logoutUseCase
        self.checkLoginUseCase = checkLoginUseCase
        loadUserData()
    }
    
    func loadUserData() {
        let isLoggedIn = checkLoginUseCase.execute()
        uiState.isLoggedIn = isLoggedIn
        uiState.isGuestMode = !isLoggedIn
        
        if isLoggedIn, let user = getUserUseCase.execute() {
            uiState.userEmail = user.email ?? ""
            uiState.userName = user.displayName ?? "User"
        } else {
            uiState.userEmail = ""
            uiState.userName = "Guest"
        }
    }
    
    func handleLogout() {
        uiState.showLogoutConfirmation = true
    }
    
    func confirmLogout() {
        uiState.showLogoutConfirmation = false
        uiState.isLoading = true
        
        do {
            try logoutUseCase.execute()
            uiState.isLoggedIn = false
            uiState.isGuestMode = true
            uiState.userEmail = ""
            uiState.userName = "Guest"
            uiState.errorMessage = nil
        } catch {
            uiState.errorMessage = error.localizedDescription
        }
        
        uiState.isLoading = false
    }
    
    func showHelp() {
        uiState.showHelpAlert = true
    }
    
    func navigateToProfile() {
        // Navigate to Profile screen
        // This will be handled in the view via coordinator or navigation
    }
    
    func navigateToShippingAddresses() {
        // Navigate to Address section in Profile
    }
    
    func navigateToPaymentMethods() {
        // Navigate to Payment section in Profile
    }
    
    func navigateToMyOrders() {
        // Navigate to Orders screen
    }
    
    func navigateToChangePassword() {
        // Navigate to Change Password screen
    }
}