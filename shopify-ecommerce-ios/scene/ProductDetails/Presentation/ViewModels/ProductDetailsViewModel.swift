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

    @Published private(set) var uiState = ProductDetailsScreenUIState()
    @Published var alertMessage: String? = nil
    var alertTitle: String = ""
    @Published var isAddedToCartSuccess: Bool = false

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

        uiState.isLoading = true
        uiState.error = nil

        do {
            let product = try await getProductDetailsUseCase.execute(productId: productId)
            uiState.data = product.toUIState()
            uiState.isLoading = false
        } catch {
            logger.error("Failed to load product \(self.productId): \(error.localizedDescription)")
            uiState.error = AppError.determine()
            uiState.isLoading = false
        }
    }

    func selectSize(_ size: String) {
        guard let currentState = uiState.data else { return }
        uiState.data = currentState.withSelectedSize(size)
    }

    // MARK: - Add to Cart

    func addToCart() {
        guard let state = uiState.data,
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
            isAddedToCartSuccess = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                self.isAddedToCartSuccess = false
            }
        } else {
            logger.warning("Variant \(variantId) already in cart")
            alertTitle = "Already in Cart"
            alertMessage = "This variant is already in your cart."
        }
    }
}
