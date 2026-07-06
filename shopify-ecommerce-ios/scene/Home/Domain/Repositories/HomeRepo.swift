//
//  HomeRepo.swift
//  shopify-ecommerce-ios
//
//  Created by albaraa alsayed on 15/01/1448 AH.
//

import Foundation

protocol HomeRepo {
    func getProducts() async throws -> [Product]
    func getCategories() async throws -> [Category]
    func getBrands() async throws -> [Category]
}
