//
//  FavoriteProduct.swift
//  shopify-ecommerce-ios
//
//  Created by Ehab Salah on 07/07/2026.
//

import Foundation
import SwiftData

@Model
final class FavoriteProduct {
    @Attribute(.unique) var id: Int
    var image: String
    var name: String
    var productDescription: String
    var price: Float
    var isAvailable: Bool
    var productType: String
    var vendor: String
    var dateAdded: Date
    
    init(id: Int, image: String, name: String, productDescription: String, price: Float, isAvailable: Bool, productType: String, vendor: String, dateAdded: Date = Date()) {
        self.id = id
        self.image = image
        self.name = name
        self.productDescription = productDescription
        self.price = price
        self.isAvailable = isAvailable
        self.productType = productType
        self.vendor = vendor
        self.dateAdded = dateAdded
    }
}
