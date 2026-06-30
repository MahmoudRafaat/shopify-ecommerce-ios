//
//  HomeRepo.swift
//  shopify-ecommerce-ios
//
//  Created by albaraa alsayed on 15/01/1448 AH.
//

import Foundation

protocol HomeRepo {
    func getProducts() -> [Product]
    func getCategories() -> [Category]
}
