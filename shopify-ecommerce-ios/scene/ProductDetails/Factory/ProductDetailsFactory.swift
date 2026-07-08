//
//  ProductDetailsFactory.swift
//  shopify-ecommerce-ios
//
//  Created by albaraa alsayed on 22/01/1448 AH.
//

import Foundation

@MainActor
class ProductDetailsFactory {
    static func makeProductDetailsViewModel(productId: Int) -> ProductDetailsViewModel {
        let remoteDataSource = ProductDetailsRemoteDataSourceImpl()
        let repository = ProductDetailsRepositoryImpl(remoteDataSource: remoteDataSource)
        let useCase = GetProductDetailsUseCaseImpl(repository: repository)
        return ProductDetailsViewModel(productId: productId, getProductDetailsUseCase: useCase)
    }
}
