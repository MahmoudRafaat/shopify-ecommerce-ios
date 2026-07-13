//
//  Tab.swift
//  shopify-ecommerce-ios
//
//  Created by albaraa alsayed on 13/01/1448 AH.
//

import Foundation

enum Tab: String, CaseIterable {
    case home = "Home"
    case wishlist = "Wishlist"
    case cart = ""
    case search = "Search"
    case settings = "Settings"
    
    func iconName(isActive: Bool) -> String {
        switch self {
        case .home: return isActive ? "house.fill" : "house"
        case .wishlist: return isActive ? "heart.fill" : "heart"
        case .cart: return "cart"
        case .search: return "magnifyingglass"
        case .settings: return isActive ? "gearshape.fill" : "gearshape"
        }
    }
}


