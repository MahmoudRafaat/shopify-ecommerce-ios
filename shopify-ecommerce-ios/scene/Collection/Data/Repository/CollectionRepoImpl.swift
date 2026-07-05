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
            let totalQuantity = dto.variants.reduce(0) { $0 + $1.inventoryQuantity }
            return ProductCollection(
                id: dto.id,
                image: dto.image?.src ?? "placeholder_image",
                name: dto.title,
                description: dto.bodyHtml ?? "No description available.",
                price: Float(dto.variants.first?.price ?? "0.0") ?? 0.0,
                isAvailabe: totalQuantity > 0,
                productType: dto.productType
            )
        }
    }
    
    
}
