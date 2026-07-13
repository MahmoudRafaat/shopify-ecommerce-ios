//
//  HomeUIState.swift
//  shopify-ecommerce-ios
//
//  Created by albaraa alsayed on 24/01/1448 AH.
//

import Foundation

struct HomeUIState {
    var categories: [Category] = []
    var brands: [Category] = []
    var categorySections: [(title: String, products: [Product])] = []
    
    var isCategoriesLoading: Bool = true
    var isBrandsLoading: Bool = true
    var isProductsLoading: Bool = true
    
    var error: AppError? = nil
}
