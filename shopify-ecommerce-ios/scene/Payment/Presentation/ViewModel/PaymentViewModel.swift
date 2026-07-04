//
//  CartViewModel.swift
//  shopify-ecommerce-ios
//
//  Created by albaraa alsayed on 18/01/1448 AH.
//

import Foundation
import Observation

@Observable
class PaymentViewModel {
    let paymentMethods : [PaymentMethodState] = [
        PaymentMethodState(id: 1, icon: "visa", numbers: "*********2109"),
        PaymentMethodState(id: 2, icon: "paypal", numbers: "*********3309"),
        PaymentMethodState(id: 3, icon: "dollars", numbers: "Cash On Delivery"),
    ]
    var cartProducts: [CartProduct] = []
    
    init() {
        loadMockData()
    }
    
    private func loadMockData() {
        cartProducts = [
            CartProduct(
                id: 1,
                image: "watch",
                name: "Nike Air Max 270",
                colors: ["Black", "White"],
                price: 120.00,
                rating: 4.5,
                discount: 15.0,
                oldPrice: 150.00,
                numberOfItems: 1
            ),
            CartProduct(
                id: 2,
                image: "watch",
                name: "Apple Watch Series 9",
                colors: ["Midnight", "Starlight", "Red"],
                price: 399.00,
                rating: 4.8,
                discount: 0.0,
                oldPrice: 399.00,
                numberOfItems: 2
            ),
            CartProduct(
                id: 3,
                image: "watch",
                name: "Sony Noise Cancelling Headphones",
                colors: ["Silver", "Black"],
                price: 298.50,
                rating: 4.7,
                discount: 50.0,
                oldPrice: 348.50,
                numberOfItems: 1
            ),
            CartProduct(
                id: 4,
                image: "watch",
                name: "Cotton Basic T-Shirt",
                colors: ["Gray", "Navy Blue"],
                price: 15.99,
                rating: 4.2,
                discount: 20.0,
                oldPrice: 19.99,
                numberOfItems: 3
            ),
            CartProduct(
                id: 5,
                image: "watch",
                name: "Leather Minimalist Wallet",
                colors: ["Brown"],
                price: 45.00,
                rating: 4.9,
                discount: 10.0,
                oldPrice: 55.00,
                numberOfItems: 1
            )
        ]
    }
}
