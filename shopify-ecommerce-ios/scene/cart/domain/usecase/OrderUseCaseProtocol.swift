//
//  OrderUseCaseProtocol.swift
//  shopify-ecommerce-ios
//
//  Created by Ehab Salah on 05/07/2026.
//

import Foundation

protocol CreateDraftOrderUseCase {
    func execute(products: [ProductDataModel]) async throws -> CheckoutOrderInfo
}

protocol GetDraftOrderUseCase {
    func execute(draftOrderId: Int) async throws -> CheckoutOrderInfo
}

protocol UpdateDraftOrderLineItemsUseCase {
    func execute(draftOrderId: Int, lineItems: [OrderItemUIModel]) async throws -> CheckoutOrderInfo
}

protocol ApplyDiscountUseCase {
    func execute(draftOrderId: Int, discountCode: String, priceRule: PriceRuleResponse) async throws -> CheckoutOrderInfo
}

protocol RemoveDiscountUseCase {
    func execute(draftOrderId: Int) async throws -> CheckoutOrderInfo
}

protocol CompleteDraftOrderUseCase {
    func execute(draftOrderId: Int) async throws -> CheckoutOrderInfo
}

protocol UpdateDraftOrderAddressUseCase {
    func execute(draftOrderId: Int, address: DraftAddressRequest) async throws -> CheckoutOrderInfo
}

protocol RemoveLineItemUseCase {
    func execute(draftOrderId: Int, variantId: Int, currentLineItems: [OrderItemUIModel]) async throws -> CheckoutOrderInfo
}

protocol DeleteDraftOrderUseCase {
    func execute(draftOrderId: Int) async throws
}

protocol FetchActiveDiscountCodesUseCase {
    func execute() async throws -> [String: PriceRuleResponse]
}

protocol GetCustomerCartMetafieldUseCase {
    func execute() async throws -> MetafieldResponse?
}

protocol SetCustomerCartMetafieldUseCase {
    func execute(draftOrderId: Int) async throws
}
