//
//  HomeCoordinator.swift
//  shopify-ecommerce-ios
//
//  Created by albaraa alsayed on 15/01/1448 AH.
//

import SwiftUI
import Observation

@Observable
final class HomeCoordinator {

    enum Destination: Hashable {
        case productDetail(productId: Int)
        case categoriesScreen(categoryId: Int)
        case profileDetails
    }

    var navigationPath = NavigationPath()

    var showNetworkAlert = false

    // Full-screen presentation state for the AI Assistant
    var isShowingAIAssistant = false

    func goToProductDetail(id: Int) {
        guard NetworkMonitor.shared.isConnected else { showNetworkAlert = true; return }
        print("GOING TO PRODUCT:", id)
        navigationPath.append(Destination.productDetail(productId: id))
    }

    func goToCategoriesScreen(id: Int) {
        guard NetworkMonitor.shared.isConnected else { showNetworkAlert = true; return }
        navigationPath.append(Destination.categoriesScreen(categoryId: id))
    }

    func goToProfile() {
        guard NetworkMonitor.shared.isConnected else { showNetworkAlert = true; return }
        print("Pushing from coordinator:", ObjectIdentifier(self))
        navigationPath.append(Destination.profileDetails)
    }

    func goToAIAssistant() {
        isShowingAIAssistant = true
    }

    func dismissAIAssistant() {
        isShowingAIAssistant = false
    }
}
