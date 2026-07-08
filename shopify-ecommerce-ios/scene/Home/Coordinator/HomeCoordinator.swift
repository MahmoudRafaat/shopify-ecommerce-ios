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
        case settings
    }

    var navigationPath = NavigationPath()

    // Full-screen presentation state for the AI Assistant
    var isShowingAIAssistant = false

    func goToProductDetail(id: Int) {
        print("GOING TO PRODUCT:", id)
        navigationPath.append(Destination.productDetail(productId: id))
    }

    func goToCategoriesScreen(id: Int) {
        navigationPath.append(Destination.categoriesScreen(categoryId: id))
    }

    func goToSettings() {
        print("Pushing from coordinator:", ObjectIdentifier(self))
        navigationPath.append(Destination.settings)
    }

    func goToAIAssistant() {
        isShowingAIAssistant = true
    }

    func dismissAIAssistant() {
        isShowingAIAssistant = false
    }
}
