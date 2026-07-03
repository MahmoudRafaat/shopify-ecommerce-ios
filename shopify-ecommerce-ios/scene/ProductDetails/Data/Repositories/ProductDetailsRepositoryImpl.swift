//
//  ProductDetailsRepositoryImpl.swift
//  shopify-ecommerce-ios
//
//  Created by Yomna on 03/07/2026.
//

import Foundation

final class ProductDetailsRepositoryImpl: ProductDetailsRepository {

    private let service: ProductDetailsServiceProtocol

    init(service: ProductDetailsServiceProtocol) {
        self.service = service
    }

    func getProduct(by id: Int) async throws -> Product {
        fatalError("Not implemented yet")
    }
}
