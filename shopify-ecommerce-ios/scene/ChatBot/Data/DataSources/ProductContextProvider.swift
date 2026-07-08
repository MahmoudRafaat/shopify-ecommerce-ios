//
//  ProductContextProvider.swift
//  shopify-ecommerce-ios
//
//  Created by Mahmoud Raafat Mustafa on 07/07/2026.
//

import Foundation

protocol ProductContextProviderProtocol {
    func getStoreOverview() async throws -> StoreOverview
    func getAllProducts() async throws -> [Product]
    func getAllCategories() async throws -> [Category]
    func searchProducts(query: String, limit: Int) async throws -> [Product]
}

struct StoreOverview {
    let brandNames: [String]
    let categoryNames: [String]
}

class ProductContextProvider: ProductContextProviderProtocol {
    private let homeRepo: HomeRepo

    init(homeRepo: HomeRepo) {
        self.homeRepo = homeRepo
    }

    func getStoreOverview() async throws -> StoreOverview {
        let products = try await homeRepo.getProducts()
        let categories = try await homeRepo.getCategories()

        let brandNames = Array(Set(products.map { $0.vendor })).prefix(15)
        let categoryNames = categories.map { $0.title }

        return StoreOverview(
            brandNames: Array(brandNames),
            categoryNames: categoryNames
        )
    }

    func getAllProducts() async throws -> [Product] {
        try await homeRepo.getProducts()
    }

    func getAllCategories() async throws -> [Category] {
        let categories = try await homeRepo.getCategories()
        let brands = try await homeRepo.getBrands()
        return categories + brands
    }

    
    func searchProducts(query: String, limit: Int = 8) async throws -> [Product] {
        guard !query.trimmingCharacters(in: .whitespaces).isEmpty else { return [] }

        let products = try await homeRepo.getProducts()
        let terms = query.lowercased().components(separatedBy: .whitespaces).filter { !$0.isEmpty }

        let scored = products.compactMap { product -> (Product, Int)? in
            let haystack = "\(product.name) \(product.description) \(product.vendor) \(product.productType)".lowercased()
            let score = terms.reduce(0) { partial, term in
                haystack.contains(term) ? partial + 1 : partial
            }
            return score > 0 ? (product, score) : nil
        }

        return scored
            .sorted { $0.1 > $1.1 }
            .prefix(limit)
            .map { $0.0 }
    }
}
