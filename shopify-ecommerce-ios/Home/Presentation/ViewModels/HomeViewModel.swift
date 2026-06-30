//
//  HomeViewModel.swift
//  shopify-ecommerce-ios
//
//  Created by albaraa alsayed on 14/01/1448 AH.
//

import Foundation
import Observation

@Observable
class HomeViewModel {
    
    private let repo: HomeRepo
    private(set) var products: [Product] = []
    private(set) var categories: [Category] = []
    
    init() {
        repo = HomeRepoImpl()
        products = repo.getProducts()
        categories = repo.getCategories()
    }

}
