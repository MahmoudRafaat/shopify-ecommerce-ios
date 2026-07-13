//
//  SearchProductRepo.swift
//  shopify-ecommerce-ios
//
//  Created by albaraa alsayed on 20/01/1448 AH.
//

import Foundation

protocol SearchProductRepo {
    func fetchProductsCount(query: ProductQuery) async throws -> Int
    func fetchProducts(query: ProductQuery) async throws -> (products: [SearchProduct], nextPageURL: URL?)
    func fetchNextPage(url: URL) async throws -> (products: [SearchProduct], nextPageURL: URL?)
    func fetchFilterOptions() async throws -> (vendors: [SearchVendor], categories: [SearchCategory])
}
