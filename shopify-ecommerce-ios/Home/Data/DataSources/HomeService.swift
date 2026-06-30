//
//  HomeService.swift
//  shopify-ecommerce-ios
//
//  Created by albaraa alsayed on 15/01/1448 AH.
//

import Foundation

protocol HomeServiceProtocol: AnyObject {
    func loadProducts() -> [Product]
    func loadCategories() -> [Category]
}

class HomeService : HomeServiceProtocol {
    func loadProducts() -> [Product] {
        return [
            Product(
                image: "watch",
                name: "2021 Pilot's Watch",
                description: "IWC Schaffhausen 2021 Pilot's Watch \"SIHH 2019\" 44mm",
                price: 1500.0,
                discount: 40,
                stars: 4.4,
                reviewers: 3455
            ),
            Product(
                image: "watch",
                name: "Elegant Summer Dress",
                description: "Comfortable and stylish outfit for everyday wear",
                price: 2200.0,
                discount: 25,
                stars: 4.7,
                reviewers: 2890
            ),
            Product(
                image: "watch",
                name: "Classic Women Outfit",
                description: "Premium fabric with modern design collection",
                price: 1800.0,
                discount: 35,
                stars: 4.2,
                reviewers: 4120
            )
        ]
    }
    
    func loadCategories() -> [Category] {
        return [
            Category(title: "Beauty", imageName: "category-image"),
            Category(title: "Fashion", imageName: "category-image"),
            Category(title: "Kids", imageName: "category-image"),
            Category(title: "Mens", imageName: "category-image"),
            Category(title: "Womens", imageName: "category-image")
        ]
    }
    
    
}
