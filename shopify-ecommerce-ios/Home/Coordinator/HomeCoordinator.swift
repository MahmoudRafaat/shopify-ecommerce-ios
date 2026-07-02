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
    }
    
    var navigationPath = NavigationPath()
    
    func goToProductDetail(id: Int) {
        navigationPath.append(Destination.productDetail(productId: id))
    }
    
    func goToCategoriesScreen(id: Int) {
        navigationPath.append(Destination.categoriesScreen(categoryId: id))
    }
}
