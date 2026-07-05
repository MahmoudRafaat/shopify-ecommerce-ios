//
//  CollectionService.swift
//  shopify-ecommerce-ios
//
//  Created by albaraa alsayed on 20/01/1448 AH.
//

import Foundation

protocol CollectionServiceProtocol {
    func loadProducts(collectionId: Int) async throws -> [ProductDTO]
}

class CollectionService: CollectionServiceProtocol {
    func loadProducts(collectionId: Int) async throws -> [ProductDTO] {
        let response : ProductsResponse = try await NetworkService.request(endpoint: CollectionEndPoints.collectionProducts(collectionId: collectionId))
        return response.products
    }
}
