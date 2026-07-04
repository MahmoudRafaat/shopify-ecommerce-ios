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

    init(viewModel: ProductDetailsViewModel) {
        _viewModel = StateObject(
            wrappedValue: viewModel
        )
    }

    var body: some View {

        Group {

            if viewModel.isLoading {

                ProgressView()

            } else if let state = viewModel.uiState {

                ProductDetailsView(
                    state: state,
                    onSizeSelected: viewModel.selectSize(_:)
                )

            } else if let errorMessage = viewModel.errorMessage {

                Text(errorMessage)

            } else {
                
                VStack {
                    Text("No Data Yet")
                        .foregroundStyle(.red)

                    Text("isLoading: \(viewModel.isLoading.description)")
                    Text("error: \(viewModel.errorMessage ?? "nil")")
                }
            }
        }
        .task {
            print("Screen appeared")
            await viewModel.loadProduct()
        }
    }
}

//#Preview {
//    ProductDetailsScreen(
//        )
//}
