//
//  CollectionProduct.swift
//  shopify-ecommerce-ios
//
//  Created by albaraa alsayed on 20/01/1448 AH.
//

import Foundation

struct ProductUIState : Identifiable {
    let id: Int
    let image: String
    let name: String
    let description: String
    let price: Float
    let isAvailabe: Bool
    let discount: Int = 20
    let productType: String
    let vendor: String
    
    var oldPrice: Float {
        return price / (1 - (Float(discount) / 100.0))
    }
    
    let stars: Float = 5
    let reviewers: Int = 1098
    
    init(product: Product) {
        self.id = product.id
        self.image = product.image
        self.name = product.name
        self.description = product.description
        self.price = product.price
        self.isAvailabe = product.isAvailabe
        self.productType = product.productType
        self.vendor = product.vendor
    }
    
    init(product: ProductCollection) {
        self.id = product.id
        self.image = product.image
        self.name = product.name
        self.description = product.description
        self.price = product.price
        self.isAvailabe = product.isAvailabe
        self.productType = product.productType
        self.vendor = product.vendor
    }
    
    init (searchProduct: SearchProduct) {
        self.id = searchProduct.id
        self.image = searchProduct.image
        self.name = searchProduct.name
        self.description = searchProduct.description
        self.price = searchProduct.price
        self.isAvailabe = searchProduct.isAvailabe
        self.productType = searchProduct.productType
        self.vendor = searchProduct.vendor
    }
}
