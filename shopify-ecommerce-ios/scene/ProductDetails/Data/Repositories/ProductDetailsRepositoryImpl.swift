//
//  ProductDetailsRepositoryImpl.swift
//  shopify-ecommerce-ios
//
//  Created by Yomna on 03/07/2026.
//

import Foundation

final class ProductDetailsRepositoryImpl: ProductDetailsRepository {

    private let remoteDataSource: ProductDetailsRemoteDataSource

    init(
            remoteDataSource: ProductDetailsRemoteDataSource
        ) {
            self.remoteDataSource = remoteDataSource
        }

    func getProduct(by id: Int) async throws -> ProductDetails {
        let dto = try await remoteDataSource.getProduct(by: id)
        
        return dto.toDomain()
    }
}
