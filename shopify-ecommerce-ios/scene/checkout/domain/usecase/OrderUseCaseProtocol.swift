//
//  OrderUseCaseProtocol.swift
//  shopify-ecommerce-ios
//
//  Created by Ehab Salah on 05/07/2026.
//

import Foundation

protocol CreateDraftOrderUseCase {
    func execute(lineItems: [DraftLineItemRequest]) async throws -> DraftOrderResponse
}

protocol GetDraftOrderUseCase {
    func execute(draftOrderId: Int) async throws -> DraftOrderResponse
}

protocol UpdateDraftOrderLineItemsUseCase {
    func execute(draftOrderId: Int, lineItems: [DraftLineItemRequest]) async throws -> DraftOrderResponse
}

protocol ApplyDiscountUseCase {
    func execute(draftOrderId: Int, discountCode: String, priceRule: PriceRuleResponse) async throws -> DraftOrderResponse
}

protocol RemoveDiscountUseCase {
    func execute(draftOrderId: Int) async throws -> DraftOrderResponse
}

protocol CompleteDraftOrderUseCase {
    func execute(draftOrderId: Int) async throws -> DraftOrderResponse
}

protocol UpdateDraftOrderAddressUseCase {
    func execute(draftOrderId: Int, address: DraftAddressRequest) async throws -> DraftOrderResponse
}

protocol RemoveLineItemUseCase {
    func execute(draftOrderId: Int, variantId: Int, currentLineItems: [DraftLineItemRequest]) async throws -> DraftOrderResponse
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
