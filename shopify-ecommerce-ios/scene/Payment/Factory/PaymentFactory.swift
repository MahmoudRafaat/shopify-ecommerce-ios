//
//  PaymentFactory.swift
//  shopify-ecommerce-ios
//
//  Created by albaraa alsayed on 19/01/1448 AH.
//

import Foundation

@MainActor
final class PaymentFactory {
    static func makePaymentViewModel() -> PaymentViewModel {
        let service : PaymentService = PaymentService()
        let repository : PaymentRepo = PaymentRepoImpl(service: service)
        let totalPriceUseCase : GetTotalPriceUseCase = GetTotalPriceUseCaseImp(repository: repository)
        let paymentCardsUseCase : GetPaymentCardUseCase = GetPaymentCardUseCaseImp(repository: repository)
        return PaymentViewModel(getTotalPriceUseCase: totalPriceUseCase, getPaymentCardUseCase: paymentCardsUseCase)
    }
}
