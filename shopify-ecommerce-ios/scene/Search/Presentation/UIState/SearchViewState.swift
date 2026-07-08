//
//  SearchViewState.swift
//  shopify-ecommerce-ios
//
//  Created by albaraa alsayed on 20/01/1448 AH.
//

import Foundation

enum SearchViewState {
    case idle
    case loading
    case loadingMore
    case success([SearchProduct])
    case error(String)
}
