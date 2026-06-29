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
    
    private(set) var products: [Product] = []
    
    init() {
        loadData()
    }
    
    private func loadData() {
        self.products = [
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
}
