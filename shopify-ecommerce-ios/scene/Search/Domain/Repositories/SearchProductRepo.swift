//
//  SearchProductRepo.swift
//  shopify-ecommerce-ios
//
//  Created by albaraa alsayed on 20/01/1448 AH.
//

import Foundation

protocol SearchProductRepo {
    func fetchProducts(query: ProductQuery) async throws -> [SearchProduct]
    func fetchFilterOptions() async throws -> (vendors: [SearchVendor], categories: [SearchCategory])
}
