//
//  OrdersListViewModel.swift
//  shopify-ecommerce-ios
//
//  Created by Mahmoud Raafat Mustafa on 06/07/2026.
//


import Foundation
import Observation

@Observable
class OrdersListViewModel {
    
    private let getOrdersUseCase: GetOrdersUseCaseProtocol
    private let userDefaults: UserDefaults
    
    var uiState = OrdersUIState()
    private(set) var customerId: Int?
    
    init(
        getOrdersUseCase: GetOrdersUseCaseProtocol = OrdersUseCase(),
        userDefaults: UserDefaults = .standard
    ) {
        self.getOrdersUseCase = getOrdersUseCase
        self.userDefaults = userDefaults
        setupCustomerId()
    }
    
    private func setupCustomerId() {
        let isLoggedIn = userDefaults.bool(forKey: AppConstants.isLoggedIn)
        
        if isLoggedIn {
            customerId = userDefaults.integer(forKey: AppConstants.customerId)
            if customerId == 0 {
                customerId = nil
            }
        }
    }
    
    @MainActor
    func loadOrders() async {
        guard let customerId = customerId else {
            uiState.isLoading = false
            uiState.errorMessage = "Please sign in to view your orders"
            return
        }
        
        uiState.isLoading = true
        uiState.errorMessage = nil
        
        do {
            let orders = try await getOrdersUseCase.execute(customerId: customerId)
            uiState.orders = orders
            uiState.isEmpty = orders.isEmpty
        } catch {
            uiState.errorMessage = error.localizedDescription
            uiState.isEmpty = true
        }
        
        uiState.isLoading = false
    }
}
