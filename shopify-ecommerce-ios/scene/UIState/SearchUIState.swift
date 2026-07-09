//
//  SearchViewState.swift
//  shopify-ecommerce-ios
//
//  Created by albaraa alsayed on 20/01/1448 AH.
//

import Foundation

struct SearchUIState {
    var isIdle: Bool = true
    var isLoading: Bool = false
    var isLoadingMore: Bool = false
    var error: AppError? = nil
}
