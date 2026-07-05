//
//  CartRepoImpl.swift
//  shopify-ecommerce-ios
//
//  Created by albaraa alsayed on 19/01/1448 AH.
//

import Foundation

class PaymentRepoImpl: PaymentRepo {
    private let service: PaymentServiceProtocol

    init(service: PaymentServiceProtocol) {
        self.service = service
    }

    func getTotalPrice() async throws -> PaymentOrder {
        let order = try await service.loadDraft()

        return PaymentOrder(
            id: order.id,
            total: order.totalPrice,
            shipping: "00.00"
        )
    }
    
    func getPaymentCard() async throws -> [PaymentCardNumber] {
        let paymentCards = try await service.loadPaymentCards()
        
        return paymentCards.map { paymentCard in
            let text = paymentCard.value
            
            var cardNumber = ""
            let cardParts = text.components(separatedBy: "\"card_number\":\"")
            if cardParts.count > 1 {
                cardNumber = cardParts[1].components(separatedBy: "\"").first ?? ""
            }
            
            var isDefault = false
            let defaultParts = text.components(separatedBy: "\"is_default\":")
            if defaultParts.count > 1 {
                let defaultString = defaultParts[1].components(separatedBy: ",").first ?? "false"
                isDefault = (defaultString == "true")
            }
            
            return PaymentCardNumber(id: paymentCard.id, number: cardNumber, isDefault: isDefault)
        }
    }
}
