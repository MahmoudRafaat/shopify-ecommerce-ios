//
//  PaymentViewModel.swift
//  shopify-ecommerce-ios
//
//  Created by albaraa alsayed on 18/01/1448 AH.
//

import Foundation
import Observation

// No UIKit import — the ViewModel is platform-agnostic.

@Observable
@MainActor
final class PaymentViewModel {

    // MARK: - Injected dependencies

    private let getTotalPriceUseCase: GetTotalPriceUseCase
    private let completeOrderUseCase: CompleteOrderUseCase
    /// Hides UIKit, configuration loading, and SDK orchestration behind a
    /// single protocol. The ViewModel never knows how payment is presented.
    private let coordinator: PaymentFlowCoordinating

    // MARK: - Observed state

    var totalPrice: String = ""
    var orderId: Int?

    /// The result of the most recent Paymob payment attempt.
    var paymentResult: PaymentResult?
    /// Set when any error occurs; cleared at the start of each new operation.
    var paymentError: String?
    /// `true` while a payment session is in-flight.
    var isProcessingPayment: Bool = false

    // MARK: - Static UI data

    let paymentMethods: [PaymentMethodState] = [
        PaymentMethodState(id: 1, icon: "visa",    numbers: "*********2109"),
        PaymentMethodState(id: 2, icon: "paypal",  numbers: "*********3309"),
        PaymentMethodState(id: 3, icon: "dollars", numbers: "Cash On Delivery"),
    ]

    // MARK: - Init

    init(
        getTotalPriceUseCase: GetTotalPriceUseCase,
        completeOrderUseCase: CompleteOrderUseCase,
        coordinator: PaymentFlowCoordinating,
        orderId: Int
    ) {
        self.getTotalPriceUseCase = getTotalPriceUseCase
        self.completeOrderUseCase = completeOrderUseCase
        self.coordinator = coordinator
        self.orderId = orderId
    }

    // MARK: - Shopify total

    func getTotalPrice() async {
        guard let orderId else { return }
        do {
            let order = try await getTotalPriceUseCase.execute(id: orderId)
            totalPrice = order.total
            self.orderId   = order.id
        } catch {
            paymentError = error.localizedDescription
            print("[PaymentViewModel] getTotalPrice failed: \(error)")
        }
    }

    /// Indicates that the order and payment (if applicable) were completed successfully.
    var orderCompleted: Bool = false

    // MARK: - Paymob payment

    /// Starts a Paymob payment session.
    ///
    /// The ViewModel builds the domain request from the data it already holds,
    /// then hands off entirely to the coordinator. It knows nothing about
    /// UIKit, SDK internals, or how credentials are loaded.
    ///
    /// - Parameters:
    ///   - billingData: Customer billing information.
    ///   - orderDescription: Human-readable label shown on the receipt.
    ///   - paymentMethodIDs: Paymob integration IDs (card, Apple Pay, etc.).
    func startPaymobPayment(
        billingData: PaymobBillingData,
        orderDescription: String = "Shopify Order",
        paymentMethodIDs: [Int]
    ) async {
        guard !isProcessingPayment else { return }

        paymentResult = nil
        paymentError  = nil
        isProcessingPayment = true
        defer { isProcessingPayment = false }

        // Domain-layer money conversion — no arithmetic in the ViewModel.
        let amountCents = MoneyConverter.toCents(from: totalPrice)

        let request = PaymobPaymentRequest(
            amountCents: amountCents,
            currency: "EGP",
            paymentMethodIDs: paymentMethodIDs,
            billingData: billingData,
            items: [
                PaymobOrderItem(
                    name: orderDescription,
                    amountCents: amountCents,
                    itemDescription: orderDescription,
                    quantity: 1
                )
            ],
            extras: orderId.map { ["order_id": String($0)] }
        )

        do {
            let result = try await coordinator.startPayment(request: request)
            paymentResult = result
            print("[PaymentViewModel] Payment result: \(result)")
        } catch {
            paymentError = error.localizedDescription
            print("[PaymentViewModel] Payment failed: \(error)")
        }
    }

    // MARK: - Unified Checkout Flow (COD & Card)

    /// Orchestrates the checkout process depending on the selected payment method.
    /// - Parameter selectedIndex: 0 = Visa (Paymob), 1 = Paypal (Paymob), 2 = Cash on Delivery.
    func checkout(selectedIndex: Int) async {
        guard let orderId else { return }
        paymentError = nil
        orderCompleted = false

        let isCOD = (selectedIndex == 2)

        if isCOD {
            do {
                try await completeOrderUseCase.execute(id: orderId, paymentPending: true)
                CartService.shared.clear()
                orderCompleted = true
                print("[PaymentViewModel] COD Order \(orderId) completed.")
            } catch {
                paymentError = error.localizedDescription
                print("[PaymentViewModel] completeOrder failed: \(error)")
            }
        } else {
            // Card payment flow (Visa or Paypal/Apple Pay)
            let billing = PaymobBillingData(
                firstName: "Customer",
                lastName: ".",
                email: "customer@example.com",
                phoneNumber: "+201000000000"
            )
            
            // Default dummy Paymob Integration ID for Card payment
            let cardIntegrationID = 4554316
            
            await startPaymobPayment(
                billingData: billing,
                orderDescription: "Shopify Order #\(orderId)",
                paymentMethodIDs: [cardIntegrationID]
            )
            
            if case .success = paymentResult {
                do {
                    // Payment succeeded -> Complete order on Shopify
                    try await completeOrderUseCase.execute(id: orderId, paymentPending: false)
                    CartService.shared.clear()
                    orderCompleted = true
                    print("[PaymentViewModel] Card Order \(orderId) completed after successful payment.")
                } catch {
                    paymentError = error.localizedDescription
                    print("[PaymentViewModel] completeOrder after payment failed: \(error)")
                }
            } else if case .failure(let reason) = paymentResult {
                paymentError = "Payment failed: \(reason)"
            } else if case .pending = paymentResult {
                paymentError = "Payment is pending verification."
            }
        }
    }
}
