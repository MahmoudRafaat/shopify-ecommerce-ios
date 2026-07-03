//
//  ProductDetailsViewModel.swift
//  shopify-ecommerce-ios
//
//  Created by Yomna on 03/07/2026.
//

import Foundation

@MainActor
final class ProductDetailsViewModel: ObservableObject {

    @Published var isLoading = false

    init() {}

    func loadProduct(id: Int) async {
        // TODO
    }
}
