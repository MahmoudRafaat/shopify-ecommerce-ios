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
            let totalQuantity = dto.variants.reduce(0) { $0 + $1.inventoryQuantity }
            print(totalQuantity)
            return Product(
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
    
    func getCategories() async throws -> [Category] {
        let data = try await service.loadCategories()
        
        return data.map{ data in
            Category(
                id: data.id,
                title: data.title,
                imageName: data.image?.src ?? "placeholder_image")
        }
    }
}
