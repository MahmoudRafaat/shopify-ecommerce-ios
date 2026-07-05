//
//  CheckoutUseCase.swift
//  shopify-ecommerce-ios
//
//  Created by Ehab Salah on 03/07/2026.
//

import Foundation

struct CreateDraftOrderUseCaseImpl: CreateDraftOrderUseCase {
    let repository: CheckoutRepository
    
    func execute(lineItems: [DraftLineItemRequest]) async throws -> DraftOrderResponse {
        return try await repository.createDraftOrder(lineItems: lineItems)
    }
}

struct GetDraftOrderUseCaseImpl: GetDraftOrderUseCase {
    let repository: CheckoutRepository
    
    func execute(draftOrderId: Int) async throws -> DraftOrderResponse {
        return try await repository.getDraftOrder(draftOrderId: draftOrderId)
    }
}

struct GetCustomerCartMetafieldUseCaseImpl: GetCustomerCartMetafieldUseCase {
    let repository: CheckoutRepository
    
    func execute() async throws -> MetafieldResponse? {
        return try await repository.getCustomerCartMetafield()
    }
}

struct SetCustomerCartMetafieldUseCaseImpl: SetCustomerCartMetafieldUseCase {
    let repository: CheckoutRepository
    
    func execute(draftOrderId: Int) async throws {
        try await repository.setCustomerCartMetafield(draftOrderId: draftOrderId)
    }
}



struct UpdateDraftOrderLineItemsUseCaseImpl: UpdateDraftOrderLineItemsUseCase {
    let repository: CheckoutRepository
    
    func execute(draftOrderId: Int, lineItems: [DraftLineItemRequest]) async throws -> DraftOrderResponse {
        return try await repository.updateDraftOrderLineItems(draftOrderId: draftOrderId, lineItems: lineItems)
    }
}



struct ApplyDiscountUseCaseImpl: ApplyDiscountUseCase {
    let repository: CheckoutRepository
    
    func execute(draftOrderId: Int, discountCode: String, priceRule: PriceRuleResponse) async throws -> DraftOrderResponse {
        let cleanValue = priceRule.value.replacingOccurrences(of: "-", with: "")
        
        let discount = DraftAppliedDiscountRequest(
            description: "Discount code: \(discountCode)",
            value: cleanValue,
            title: discountCode,
            amount: nil,
            valueType: priceRule.valueType
        )
        return try await repository.applyDiscount(draftOrderId: draftOrderId, discount: discount)
    }
}

struct RemoveDiscountUseCaseImpl: RemoveDiscountUseCase {
    let repository: CheckoutRepository
    
    func execute(draftOrderId: Int) async throws -> DraftOrderResponse {
        return try await repository.removeDiscount(draftOrderId: draftOrderId)
    }
}

struct CompleteDraftOrderUseCaseImpl: CompleteDraftOrderUseCase {
    let repository: CheckoutRepository
    
    func execute(draftOrderId: Int) async throws -> DraftOrderResponse {
        return try await repository.completeDraftOrder(draftOrderId: draftOrderId)
    }
}

struct UpdateDraftOrderAddressUseCaseImpl: UpdateDraftOrderAddressUseCase {
    let repository: CheckoutRepository
    
    func execute(draftOrderId: Int, address: DraftAddressRequest) async throws -> DraftOrderResponse {
        return try await repository.updateDraftOrderAddress(draftOrderId: draftOrderId, address: address)
    }
}

struct RemoveLineItemUseCaseImpl: RemoveLineItemUseCase {
    let repository: CheckoutRepository
    
    func execute(draftOrderId: Int, variantId: Int, currentLineItems: [DraftLineItemRequest]) async throws -> DraftOrderResponse {
        return try await repository.removeLineItem(draftOrderId: draftOrderId, variantId: variantId, currentLineItems: currentLineItems)
    }
}

struct DeleteDraftOrderUseCaseImpl: DeleteDraftOrderUseCase {
    let repository: CheckoutRepository
    
    func execute(draftOrderId: Int) async throws {
        try await repository.deleteDraftOrder(draftOrderId: draftOrderId)
    }
}

struct FetchActiveDiscountCodesUseCaseImpl: FetchActiveDiscountCodesUseCase {
    let repository: CheckoutRepository
    
    func execute() async throws -> [String: PriceRuleResponse] {
        return try await repository.fetchActiveDiscountCodes()
    }
}




