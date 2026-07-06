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
    let completeOrderUseCase: CompleteOrderUseCase
    var totalPrice: String = ""
    var orderId: Int?
    
    init(getTotalPriceUseCase: GetTotalPriceUseCase, completeOrderUseCase: CompleteOrderUseCase) {
        self.getTotalPriceUseCase = getTotalPriceUseCase
        self.completeOrderUseCase = completeOrderUseCase
    }
    
    let paymentMethods : [PaymentMethodState] = [
        PaymentMethodState(id: 1, icon: "visa", numbers: "*********2109"),
        PaymentMethodState(id: 2, icon: "paypal", numbers: "*********3309"),
        PaymentMethodState(id: 3, icon: "dollars", numbers: "Cash On Delivery"),
    ]
    
    func getTotalPrice() async {
        do {
            let order = try await getTotalPriceUseCase.execute()
            self.totalPrice = order.total
            self.orderId = order.id
        } catch {
            print("Couldnt get total price: \(error)")
        }
    }
    
    func completeOrder(selectedIndex: Int) async {
        guard let orderId = orderId else { return }
        do {
            // 2 is the index for Cash On Delivery in paymentMethods
            let isCashOnDelivery = (selectedIndex == 2)
            try await completeOrderUseCase.execute(id: orderId, paymentPending: isCashOnDelivery)
            print("Order completed successfully!")
        } catch {
            print("Couldn't complete order: \(error)")
        }
    }
}
