//
//  OrdersUIState.swift
//  shopify-ecommerce-ios
//
//  Created by Mahmoud Raafat Mustafa on 06/07/2026.
//


import Foundation

struct OrdersUIState {
    var orders: [OrderDisplayModel] = []
    var isLoading: Bool = false
    var isEmpty: Bool = false
    var error: AppError? = nil
}
