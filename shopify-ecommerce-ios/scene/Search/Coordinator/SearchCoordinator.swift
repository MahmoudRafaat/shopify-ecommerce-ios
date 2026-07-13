//
//  SearchCoordinator.swift
//  shopify-ecommerce-ios
//
//  Created by albaraa alsayed on 21/01/1448 AH.
//

import SwiftUI
import Observation

@Observable
final class SearchCoordinator {
    
    enum Destination: Hashable {
        case productDetail(productId: Int)
    }
    
    var navigationPath = NavigationPath()
    var showNetworkAlert = false
    
    func goToProductDetail(id: Int) {
        guard NetworkMonitor.shared.isConnected else { showNetworkAlert = true; return }
        print("SearchCoordinator: goToProductDetail called with id: \(id)")
        navigationPath.append(Destination.productDetail(productId: id))
    }
    
}
