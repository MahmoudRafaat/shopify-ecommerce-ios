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
            let variants = dto.variants ?? []
            let totalQuantity = variants.reduce(0) { $0 + ($1.inventoryQuantity ?? 0) }
            return Product(
                id: dto.id ?? 0,
                image: dto.image?.src ?? "placeholder_image",
                name: dto.title ?? "Product name",
                description: dto.bodyHtml ?? "Product description",
                vendor: dto.vendor ?? "Product vendor",
                price: Float(variants.first?.price ?? "0.0") ?? 0.0,
                isAvailabe: totalQuantity > 0,
                productType: dto.productType ?? ""
            )
        }
    }
    
    func getProductsByCollection(id: Int) async throws -> [Product] {
        let dtos = try await service.loadCollectionProducts(id: id)

        return dtos.map { dto in
            let variants = dto.variants ?? []
            let totalQuantity = variants.reduce(0) { $0 + ($1.inventoryQuantity ?? 0) }
            return Product(
                id: dto.id ?? 0,
                image: dto.image?.src ?? "placeholder_image",
                name: dto.title ?? "Product name",
                description: dto.bodyHtml ?? "Product description",
                vendor: dto.vendor ?? "Product vendor",
                price: Float(variants.first?.price ?? "0.0") ?? 0.0,
                isAvailabe: totalQuantity > 0,
                productType: dto.productType ?? ""
            )
        }
    }
    
    func getCategories() async throws -> [Category] {
        let data = try await service.loadCategories()
        
        return data.map{ data in
            Category(
                id: data.id ?? 0,
                title: data.title ?? "Category",
                imageName: data.image?.src ?? "placeholder_image")
        }
    }
    
    func getBrands() async throws -> [Category] {
        let data = try await service.loadBrands()
        
        return data.map{ data in
            Category(
                id: data.id ?? 0,
                title: data.title ?? "Brand",
                imageName: data.image?.src ?? "placeholder_image")
        }
    }
}
