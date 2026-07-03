//
//  ProductDetailsRepository.swift
//  shopify-ecommerce-ios
//
//  Created by Yomna on 03/07/2026.
//

import Foundation

protocol ProductDetailsRepository {
    func getProduct(by id: Int) async throws -> Product
}
