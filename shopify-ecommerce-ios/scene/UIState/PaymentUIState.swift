//
//  PaymentUIState.swift
//  shopify-ecommerce-ios
//

import Foundation

struct PaymentUIState {
    var isLoading: Bool = false
    var error: AppError? = nil
    var orderCompleted: Bool = false
}
