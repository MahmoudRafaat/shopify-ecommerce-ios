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
    @Published var alertMessage: String? = nil
    var alertTitle: String = ""

    private let productId: Int
    private let getProductDetailsUseCase: GetProductDetailsUseCase
    private let cartService: CartService

    private let logger = Logger(
        subsystem: "shopify-ecommerce-ios",
        category: "ProductDetailsViewModel"
    )

    init(
        productId: Int,
        getProductDetailsUseCase: GetProductDetailsUseCase,
        cartService: CartService = .shared
    ) {
        self.productId = productId
        self.getProductDetailsUseCase = getProductDetailsUseCase
        self.cartService = cartService
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

    // MARK: - Add to Cart

    func addToCart() {
        guard case .success(let state) = screenState,
              let variantId = state.selectedVariantId else {
            logger.warning("Cannot add to cart — no variant selected")
            return
        }

        let product = ProductDataModel(
            variantId: variantId,
            quantity: 1,
            imageUrl: state.firstImageUrl
        )

        let added = cartService.addProduct(product)

        if added {
            logger.info("Added variant \(variantId) to cart")
            alertTitle = "Added to Cart"
            alertMessage = "Product has been added to your cart successfully."
        } else {
            logger.warning("Variant \(variantId) already in cart")
            alertTitle = "Already in Cart"
            alertMessage = "This variant is already in your cart."
        }
    }
}
