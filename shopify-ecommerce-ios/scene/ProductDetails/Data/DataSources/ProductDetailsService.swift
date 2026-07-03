//
//  ProductDetailsService.swift
//  shopify-ecommerce-ios
//
//  Created by Yomna on 03/07/2026.
//

import Foundation


protocol ProductDetailsServiceProtocol {
    func getProduct(by id: Int) async throws -> ProductDTO
}

final class ProductDetailsService: ProductDetailsServiceProtocol {

    func getProduct(by id: Int) async throws -> ProductDTO {
        fatalError("Not implemented yet")
    }
}
