//
//  SearchProductRepoImpl.swift
//  shopify-ecommerce-ios
//
//  Created by albaraa alsayed on 20/01/1448 AH.
//

import Foundation

class SearchProductRepoImpl: SearchProductRepo {
    private let dataSource: SearchDataSourceProtocol
    
    init(dataSource: SearchDataSourceProtocol) {
        self.dataSource = dataSource
    }
    
    func fetchProducts(query: ProductQuery) async throws -> [SearchProduct] {
        let dtos = try await dataSource.loadProducts(query: query)
        
        return dtos.map { dto in
            let totalQuantity = dto.variants.reduce(0) { $0 + $1.inventoryQuantity }
            return SearchProduct(
                id: dto.id,
                image: dto.image?.src ?? "placeholder_image",
                name: dto.title,
                description: dto.bodyHtml ?? "No description available.",
                vendor: dto.vendor,
                price: Float(dto.variants.first?.price ?? "0.0") ?? 0.0,
                isAvailabe: totalQuantity > 0,
                productType: dto.productType
            )
        }
    }
    
    func fetchFilterOptions() async throws -> (vendors: [SearchVendor], categories: [SearchCategory]) {
        async let smartCollectionsTask = dataSource.loadSmartCollections()
        async let customCollectionsTask = dataSource.loadCustomCollections()
        
        let (smartDtos, customDtos) = try await (smartCollectionsTask, customCollectionsTask)
        
        let vendors = smartDtos.map { dto in
            SearchVendor(id: dto.id, title: dto.title)
        }
        let categories = customDtos.map { dto in
            SearchCategory(id: dto.id, title: dto.title)
        }
        
        return (vendors, categories)
    }
}
