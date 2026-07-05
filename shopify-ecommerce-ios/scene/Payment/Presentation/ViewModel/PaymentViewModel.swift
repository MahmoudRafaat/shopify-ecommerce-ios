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
    let getTotalPriceUseCase: GetTotalPriceUseCase
    var totalPrice: String = ""
    init(getTotalPriceUseCase: GetTotalPriceUseCase) {
        self.getTotalPriceUseCase = getTotalPriceUseCase
    }
    
    let paymentMethods : [PaymentMethodState] = [
        PaymentMethodState(id: 1, icon: "visa", numbers: "*********2109"),
        PaymentMethodState(id: 2, icon: "paypal", numbers: "*********3309"),
        PaymentMethodState(id: 3, icon: "dollars", numbers: "Cash On Delivery"),
    ]
    
    func getTotalPrice() async {
        do {
            totalPrice = try await getTotalPriceUseCase.execute()
        } catch {
            print("Couldnt get total price: \(error)")
        }
    }
}
