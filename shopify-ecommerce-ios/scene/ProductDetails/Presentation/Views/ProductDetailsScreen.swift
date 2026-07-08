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
            switch viewModel.screenState {

            case .loading:
                LoadingView()

            case .success(let state):
                ProductDetailsView(
                    state: state,
                    onSizeSelected: viewModel.selectSize(_:),
                    onAddToCart: viewModel.addToCart
                )

            case .error(let message):
                Text(message)
                    .foregroundStyle(.red)
            }
        }
        .task {
            await viewModel.loadProduct()
        }
        .showCustomAlert(
            title: viewModel.alertTitle,
            errorMessage: $viewModel.alertMessage
        )
    }
}
