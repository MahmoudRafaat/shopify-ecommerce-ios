//
//  ProductDetailsScreen.swift
//  shopify-ecommerce-ios
//
//  Created by Yomna on 04/07/2026.
//

import SwiftUI

struct ProductDetailsScreen: View {

    @StateObject
    private var viewModel: ProductDetailsViewModel

    init(id: Int) {
        _viewModel = StateObject(
            wrappedValue: ProductDetailsFactory.makeProductDetailsViewModel(productId: id)
        )
    }

    var body: some View {

        Group {
            if let error = viewModel.uiState.error {
                CustomContentUnavailableView(error: error, onRetry: {
                    Task { await viewModel.loadProduct() }
                })
            } else if viewModel.uiState.isLoading {
                LoadingView()
            } else if let state = viewModel.uiState.data {
                ProductDetailsView(
                    state: state,
                    onSizeSelected: viewModel.selectSize(_:),
                    onAddToCart: viewModel.addToCart
                )
            }
        }
        .task {
            await viewModel.loadProduct()
        }
        .onChange(of: viewModel.alertMessage) { _, msg in
            if let msg = msg {
                AlertManager.shared.showAlert(title: viewModel.alertTitle, message: msg)
                viewModel.alertMessage = nil
            }
        }
    }
}
