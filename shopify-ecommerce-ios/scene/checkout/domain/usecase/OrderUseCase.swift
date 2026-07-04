//
//  CheckoutUseCase.swift
//  shopify-ecommerce-ios
//
//  Created by Ehab Salah on 03/07/2026.
//

import Foundation

protocol CreateDraftOrderUseCase {
    func execute(lineItems: [DraftLineItemRequest]) async throws -> DraftOrderResponse
}

protocol UpdateDraftOrderLineItemsUseCase {
    func execute(draftOrderId: Int, lineItems: [DraftLineItemRequest]) async throws -> DraftOrderResponse
}

protocol ApplyDiscountUseCase {
    func execute(draftOrderId: Int, discountCode: String) async throws -> DraftOrderResponse
}

protocol CompleteDraftOrderUseCase {
    func execute(draftOrderId: Int) async throws -> DraftOrderResponse
}

protocol UpdateDraftOrderAddressUseCase {
    func execute(draftOrderId: Int, address: DraftAddressRequest) async throws -> DraftOrderResponse
}


struct CreateDraftOrderUseCaseImpl: CreateDraftOrderUseCase {
    let repository: CheckoutRepository
    
    func execute(lineItems: [DraftLineItemRequest]) async throws -> DraftOrderResponse {
        return try await repository.createDraftOrder(lineItems: lineItems)
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
    
    func execute(draftOrderId: Int, discountCode: String) async throws -> DraftOrderResponse {
        let discount = DraftAppliedDiscountRequest(
            description: "Discount code: \(discountCode)",
            value: "10.0", // Dummy value
            title: discountCode,
            amount: "10.00",
            valueType: "percentage" // Can be "fixed_amount" or "percentage"
        )
        return try await repository.applyDiscount(draftOrderId: draftOrderId, discount: discount)
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




