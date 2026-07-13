//
//  CheckoutUseCase.swift
//  shopify-ecommerce-ios
//
//  Created by Ehab Salah on 03/07/2026.
//

import Foundation

extension DraftOrderResponse {
    func toCheckoutOrderInfo() -> CheckoutOrderInfo {
        let totalItemsPrice = self.lineItems.reduce(0.0) { sum, item in
            sum + ((Double(item.price) ?? 0.0) * Double(item.quantity))
        }
        let originalSubtotalStr = String(format: "%.2f", totalItemsPrice)
        
        let discountAmt = self.appliedDiscount?.amount ?? "0.00"
        
        let uiItems = self.lineItems.compactMap { item -> OrderItemUIModel? in
            guard let variantId = item.variantId else { return nil }
            return OrderItemUIModel(
                id: variantId,
                title: item.title,
                variantTitle: item.name,
                price: item.price,
                quantity: item.quantity,
                imageUrl: item.properties?.first(where: { $0.name == "imageUrl" })?.value
            )
        }
        
        return CheckoutOrderInfo(
            id: self.id,
            subtotal: self.subtotalPrice,
            tax: self.totalTax,
            total: self.totalPrice,
            originalSubtotal: originalSubtotalStr,
            discountAmount: discountAmt,
            status: self.status,
            lineItems: uiItems
        )
    }
}

struct CreateDraftOrderUseCaseImpl: CreateDraftOrderUseCase {
    let repository: CheckoutRepository
    
    func execute(products: [ProductDataModel]) async throws -> CheckoutOrderInfo {
        let lineItems = products.map { product -> DraftLineItemRequest in
            var props: [LineItemProperty]? = nil
            if let img = product.imageUrl {
                props = [LineItemProperty(name: "imageUrl", value: img)]
            }
            return DraftLineItemRequest(variantId: product.variantId, quantity: product.quantity, properties: props)
        }
        let response = try await repository.createDraftOrder(lineItems: lineItems)
        return response.toCheckoutOrderInfo()
    }
}

struct GetDraftOrderUseCaseImpl: GetDraftOrderUseCase {
    let repository: CheckoutRepository
    
    func execute(draftOrderId: Int) async throws -> CheckoutOrderInfo {
        let response = try await repository.getDraftOrder(draftOrderId: draftOrderId)
        return response.toCheckoutOrderInfo()
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
    
    func execute(draftOrderId: Int, lineItems: [OrderItemUIModel]) async throws -> CheckoutOrderInfo {
        let requests = lineItems.map { uiModel -> DraftLineItemRequest in
            var props: [LineItemProperty]? = nil
            if let url = uiModel.imageUrl {
                props = [LineItemProperty(name: "imageUrl", value: url)]
            }
            return DraftLineItemRequest(variantId: uiModel.id, quantity: uiModel.quantity, properties: props)
        }
        let response = try await repository.updateDraftOrderLineItems(draftOrderId: draftOrderId, lineItems: requests)
        return response.toCheckoutOrderInfo()
    }
}



struct ApplyDiscountUseCaseImpl: ApplyDiscountUseCase {
    let repository: CheckoutRepository
    
    func execute(draftOrderId: Int, discountCode: String, priceRule: PriceRuleResponse) async throws -> CheckoutOrderInfo {
        let cleanValue = priceRule.value.replacingOccurrences(of: "-", with: "")
        
        let discount = DraftAppliedDiscountRequest(
            description: "Discount code: \(discountCode)",
            value: cleanValue,
            title: discountCode,
            amount: nil,
            valueType: priceRule.valueType
        )
        let response = try await repository.applyDiscount(draftOrderId: draftOrderId, discount: discount)
        return response.toCheckoutOrderInfo()
    }
}

struct RemoveDiscountUseCaseImpl: RemoveDiscountUseCase {
    let repository: CheckoutRepository
    
    func execute(draftOrderId: Int) async throws -> CheckoutOrderInfo {
        let response = try await repository.removeDiscount(draftOrderId: draftOrderId)
        return response.toCheckoutOrderInfo()
    }
}

struct CompleteDraftOrderUseCaseImpl: CompleteDraftOrderUseCase {
    let repository: CheckoutRepository
    
    func execute(draftOrderId: Int) async throws -> CheckoutOrderInfo {
        let response = try await repository.completeDraftOrder(draftOrderId: draftOrderId)
        return response.toCheckoutOrderInfo()
    }
}

struct UpdateDraftOrderAddressUseCaseImpl: UpdateDraftOrderAddressUseCase {
    let repository: CheckoutRepository
    
    func execute(draftOrderId: Int, address: DraftAddressRequest) async throws -> CheckoutOrderInfo {
        let response = try await repository.updateDraftOrderAddress(draftOrderId: draftOrderId, address: address)
        return response.toCheckoutOrderInfo()
    }
}

struct RemoveLineItemUseCaseImpl: RemoveLineItemUseCase {
    let repository: CheckoutRepository
    
    func execute(draftOrderId: Int, variantId: Int, currentLineItems: [OrderItemUIModel]) async throws -> CheckoutOrderInfo {
        let requests = currentLineItems.map { uiModel -> DraftLineItemRequest in
            var props: [LineItemProperty]? = nil
            if let url = uiModel.imageUrl {
                props = [LineItemProperty(name: "imageUrl", value: url)]
            }
            return DraftLineItemRequest(variantId: uiModel.id, quantity: uiModel.quantity, properties: props)
        }
        let response = try await repository.removeLineItem(draftOrderId: draftOrderId, variantId: variantId, currentLineItems: requests)
        return response.toCheckoutOrderInfo()
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




