//
//  ProductDetailsService.swift
//  shopify-ecommerce-ios
//
//  Created by Yomna on 03/07/2026.
//

import Foundation


protocol ProductDetailsRemoteDataSource {
    func getProduct(by id: Int) async throws -> ProductDTO
}

final class ProductDetailsRemoteDataSourceImpl: ProductDetailsRemoteDataSource {

    func getProduct(by id: Int) async throws -> ProductDTO {
        let response : ProductDetailsResponse = try await NetworkService.request(endpoint: ProductDetailsEndpoint.getProduct(id: id))
        print (response)
        guard let product = response.product else {
            throw NSError(domain: "ProductDetailsRemoteDataSource", code: 404, userInfo: [NSLocalizedDescriptionKey: "Product not found"])
        }
        return product
    }
}
