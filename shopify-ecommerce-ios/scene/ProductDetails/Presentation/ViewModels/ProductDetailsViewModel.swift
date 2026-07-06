//
//  ProductDetailsViewModel.swift
//  shopify-ecommerce-ios
//
//  Created by Yomna on 03/07/2026.
//

import Foundation
import os

@MainActor
final class ProductDetailsViewModel: ObservableObject {

    @Published private(set) var screenState: ProductDetailsScreenState = .loading

    private let productId: Int
    private let getProductDetailsUseCase: GetProductDetailsUseCase

    private let logger = Logger(
        subsystem: "shopify-ecommerce-ios",
        category: "ProductDetailsViewModel"
    )

    init(
        productId: Int,
        getProductDetailsUseCase: GetProductDetailsUseCase
    ) {
        self.productId = productId
        self.getProductDetailsUseCase = getProductDetailsUseCase
    }

    func loadProduct() async {
        logger.debug("Loading product \(self.productId)")

        screenState = .loading

        do {
            let product = try await getProductDetailsUseCase.execute(productId: productId)
            screenState = .success(product.toUIState())
        } catch {
            logger.error("Failed to load product \(self.productId): \(error.localizedDescription)")
            screenState = .error(error.localizedDescription)
        }
    }

    func selectSize(_ size: String) {
        guard case .success(let currentState) = screenState else { return }

        screenState = .success(currentState.withSelectedSize(size))
    }
}
