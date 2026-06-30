//
//  HomeRepoImpl.swift
//  shopify-ecommerce-ios
//
//  Created by albaraa alsayed on 15/01/1448 AH.
//

import Foundation

class HomeRepoImpl: HomeRepo {
    private let service: HomeServiceProtocol
    
    init(service: HomeServiceProtocol) {
        self.service = service
    }
    
    func getProducts() async throws -> [Product] {
        let dtos = try await service.loadProducts()
        
        return dtos.map { dto in
            Product(
                id: dto.id,
                image: dto.image?.src ?? "placeholder_image",
                name: dto.title,
                description: dto.bodyHtml ?? "No description available.",
                price: Float(dto.variants.first?.price ?? "0.0") ?? 0.0,
                isAvailabe: dto.variants.first?.inventoryQuantity ?? 0  > 0
            )
        }
    }
    
    func getCategories() async throws -> [Category] {
        return try await service.loadCategories()
    }
}
