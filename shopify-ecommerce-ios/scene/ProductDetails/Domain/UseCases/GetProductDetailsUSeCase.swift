//
//  GetProductByIDUseCase.swift
//  shopify-ecommerce-ios
//
//  Created by Yomna on 03/07/2026.
//

import Foundation

protocol GetProductDetailsUseCase {
    func execute(productId: Int) async throws -> ProductDetails
}

final class GetProductDetailsUseCaseImpl: GetProductDetailsUseCase {

    private let repository: ProductDetailsRepository

    init(repository: ProductDetailsRepository) {
        self.repository = repository
    }

    func execute(productId: Int) async throws -> ProductDetails {
        try await repository.getProduct(by: productId)
    }
}
