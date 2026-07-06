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
    
    func getCollectionProducts(collectionId: Int) async throws -> [ProductCollection] {
        let dtos = try await service.loadProducts(collectionId: collectionId)

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
