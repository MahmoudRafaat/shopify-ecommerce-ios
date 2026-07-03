//
//  GetProductByIDUseCase.swift
//  shopify-ecommerce-ios
//
//  Created by Yomna on 03/07/2026.
//

import Foundation

protocol GetProductByIdUseCaseProtocol {
    func execute(id: Int) async throws -> Product
}

final class GetProductByIdUseCase: GetProductByIdUseCaseProtocol {

    private let repository: ProductDetailsRepository

    init(repository: ProductDetailsRepository) {
        self.repository = repository
    }

    func execute(id: Int) async throws -> Product {
        fatalError("Not implemented yet")
    }
}
