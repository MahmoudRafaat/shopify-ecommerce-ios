//
//  HomeRepoImpl.swift
//  shopify-ecommerce-ios
//
//  Created by albaraa alsayed on 15/01/1448 AH.
//

import Foundation

class HomeRepoImpl: HomeRepo {
    let service : HomeService
    
    init () {
        service = HomeService()
    }
    
    func getProducts() -> [Product] {
        service.loadProducts()
    }
    
    func getCategories() -> [Category] {
        service.loadCategories()
    }
    
    
}
