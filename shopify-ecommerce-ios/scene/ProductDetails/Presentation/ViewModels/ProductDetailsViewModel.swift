//
//  ProductDetailsViewModel.swift
//  shopify-ecommerce-ios
//
//  Created by Yomna on 03/07/2026.
//

import Foundation

@MainActor
final class ProductDetailsViewModel: ObservableObject {

    @Published private(set) var uiState: ProductDetailsUIState?
    @Published private(set) var isLoading = false
    @Published private(set) var errorMessage: String?

    private let productId: Int
    private let getProductDetailsUseCase: GetProductDetailsUseCase

    init(
        productId: Int,
        getProductDetailsUseCase: GetProductDetailsUseCase
    ) {
        self.productId = productId
        self.getProductDetailsUseCase = getProductDetailsUseCase
    }

    func loadProduct() async {
        print("LOADING PRODUCT \(productId)")

        isLoading = true
        errorMessage = nil

        do {

            let product = try await
                getProductDetailsUseCase
                .execute(productId: productId)

            uiState = product.toUIState()

        } catch {

            errorMessage = error.localizedDescription
        }

        isLoading = false
    }
    func selectSize(_ size: String) {
        guard let currentState = uiState else { return }

        uiState = ProductDetailsUIState(
            imageSection: currentState.imageSection,

            sizeSection: ProductSizeSectionState(
                selectedSize: size,
                availableSizes: currentState.sizeSection.availableSizes
            ),

            infoSection: currentState.infoSection,
            deliverySection: currentState.deliverySection,
            actionsSection: currentState.actionsSection,
            similarProducts: currentState.similarProducts
        )
    }
}
