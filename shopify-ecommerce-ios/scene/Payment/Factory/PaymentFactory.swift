//
//  PaymentFactory.swift
//  shopify-ecommerce-ios
//
//  Created by albaraa alsayed on 19/01/1448 AH.
//

import Foundation

/// Builds the fully-wired `PaymentViewModel`.
///
/// Dependency graph:
/// ```
/// PaymentViewModel
///   ├── GetTotalPriceUseCaseImp
///   │     └── PaymentRepoImpl
///   │           ├── PaymentService    (Shopify draft orders)
///   │           └── PaymobService     (Paymob intention API + SDK, resolves VC internally)
///   ├── CompleteOrderUseCaseImp
///   │     └── PaymentRepoImpl (shared)
///   └── PaymentCoordinator  ← owns config loading + use-case orchestration
///         └── StartPaymentUseCaseImp
///               └── PaymentRepoImpl (shared)
/// ```
@MainActor
final class PaymentFactory {
    static func makePaymentViewModel(orderID: Int) -> PaymentViewModel {

        // MARK: Data layer
        let shopifyService: PaymentServiceProtocol = PaymentService()
        let paymobService: PaymobServiceProtocol   = PaymobService()

        // MARK: Repository — shared instance wired to both services
        let repository: PaymentRepo = PaymentRepoImpl(
            service: shopifyService,
            paymobService: paymobService
        )

        // MARK: Use cases
        let getTotalPriceUseCase: GetTotalPriceUseCase = GetTotalPriceUseCaseImp(repository: repository)
        let completeOrderUseCase: CompleteOrderUseCase  = CompleteOrderUseCaseImp(repository: repository)
        let startPaymentUseCase: StartPaymentUseCase    = StartPaymentUseCaseImp(repository: repository)

        // MARK: Coordinator — owns config loading; injected into ViewModel as a protocol
        let coordinator: PaymentFlowCoordinating = PaymentCoordinator(
            startPaymentUseCase: startPaymentUseCase
        )

        // MARK: ViewModel — UIKit-free, depends only on domain protocols
        return PaymentViewModel(
            getTotalPriceUseCase: getTotalPriceUseCase,
            completeOrderUseCase: completeOrderUseCase,
            coordinator: coordinator,
            orderId: orderID
        )
    }
}
