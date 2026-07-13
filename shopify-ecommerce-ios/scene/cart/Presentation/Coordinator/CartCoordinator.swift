//
//  CartCoordinator.swift
//  shopify-ecommerce-ios
//
//  Created by Yomna on 07/07/2026.
//

import SwiftUI
import Observation

@Observable
final class CartCoordinator {

    enum Destination: Hashable {
        case payment(draftOrderId: Int)
        case orderSuccess
    }

    var navigationPath = NavigationPath()
    var showNetworkAlert = false

    func goToPayment(draftOrderId: Int) {
        guard NetworkMonitor.shared.isConnected else { showNetworkAlert = true; return }
        navigationPath.append(Destination.payment(draftOrderId: draftOrderId))
    }

    func goToSuccess() {
        navigationPath.append(Destination.orderSuccess)
    }

    func pop() {
        navigationPath.removeLast()
    }

    func popToRoot() {
        navigationPath = NavigationPath()
    }
}
