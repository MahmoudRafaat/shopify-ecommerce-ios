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

    func goToPayment(draftOrderId: Int) {
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
