//
//  CollectionRepoImpl.swift
//  shopify-ecommerce-ios
//
//  Created by albaraa alsayed on 20/01/1448 AH.
//

import Foundation

class CollectionRepoImpl: CollectionRepo {

    let service : CollectionServiceProtocol
    
    init(service: CollectionServiceProtocol) {
        self.service = service
    }
    
    func getCollectionProducts(collectionId: Int, searchQuery: String?) async throws -> (products: [ProductCollection], nextPageURL: URL?) {
        let result = try await service.loadProducts(collectionId: collectionId, searchQuery: searchQuery)
        return (products: mapProducts(result.products), nextPageURL: result.nextPageURL)
    }
    
    func fetchNextPage(url: URL) async throws -> (products: [ProductCollection], nextPageURL: URL?) {
        let result = try await service.loadNextPage(url: url)
        return (products: mapProducts(result.products), nextPageURL: result.nextPageURL)
    }
    
    private func mapProducts(_ dtos: [ProductDTO]) -> [ProductCollection] {
        return dtos.map { dto in
            let variants = dto.variants ?? []
            let totalQuantity = variants.reduce(0) { $0 + ($1.inventoryQuantity ?? 0) }
            return ProductCollection(
                id: dto.id ?? 0,
                image: dto.image?.src ?? "placeholder_image",
                name: dto.title ?? "Product name",
                description: dto.bodyHtml ?? "Product description",
                price: Float(variants.first?.price ?? "0.0") ?? 0.0,
                isAvailabe: totalQuantity > 0,
                productType: dto.productType ?? "",
                vendor: dto.vendor ?? "Product vendor"
            )
        }
    }
}
