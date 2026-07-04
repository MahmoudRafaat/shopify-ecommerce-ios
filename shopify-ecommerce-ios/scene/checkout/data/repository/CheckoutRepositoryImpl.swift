import Foundation

final class CheckoutRepositoryImpl: CheckoutRepository {
    
    private let networkService: CheckoutNetworkServiceProtocol
    
    init(networkService: CheckoutNetworkServiceProtocol = CheckoutNetworkService()) {
        self.networkService = networkService
    }
    
    func createDraftOrder(lineItems: [DraftLineItemRequest]) async throws -> DraftOrderResponse {
        guard let customerIdString = Constants.customerId,
              let customerId = Int(customerIdString) else {
            throw NetworkError.badRequest
        }

        let request = DraftOrderRequestWrapper(draftOrder: DraftOrderRequest(
            lineItems: lineItems,
            customer: DraftCustomerRequest(id: customerId),
            useCustomerDefaultAddress: true
        ))
        
        let response = try await networkService.createDraftOrder(request: request)
        return response.draftOrder
    }
    
    func updateDraftOrderLineItems(draftOrderId: Int, lineItems: [DraftLineItemRequest]) async throws -> DraftOrderResponse {
        let request = DraftOrderRequestWrapper(draftOrder: DraftOrderRequest(
            id: draftOrderId,
            lineItems: lineItems
        )
        )
        
        let response = try await networkService.updateDraftOrder(id: draftOrderId, request: request)
        return response.draftOrder
    }
    
    func applyDiscount(draftOrderId: Int, discount: DraftAppliedDiscountRequest) async throws -> DraftOrderResponse {
        let request = DraftOrderRequestWrapper(draftOrder: DraftOrderRequest(
            id: draftOrderId,
            appliedDiscount: discount
        )
        )
        
        let response = try await networkService.updateDraftOrder(id: draftOrderId, request: request)
        return response.draftOrder
    }
    
    func completeDraftOrder(draftOrderId: Int) async throws -> DraftOrderResponse {
        let response = try await networkService.completeDraftOrder(id: draftOrderId)
        return response.draftOrder
    }
    
    func updateDraftOrderAddress(draftOrderId: Int, address: DraftAddressRequest) async throws -> DraftOrderResponse {
        let request = DraftOrderRequestWrapper(draftOrder: DraftOrderRequest(
            id: draftOrderId,
            useCustomerDefaultAddress: false, // We're providing a custom one now
            shippingAddress: address,
            billingAddress: address
        ))
        
        let response = try await networkService.updateDraftOrder(id: draftOrderId, request: request)
        return response.draftOrder
    }
    func removeLineItem(draftOrderId: Int, variantId: Int, currentLineItems: [DraftLineItemRequest]) async throws -> DraftOrderResponse {
        // Shopify removes a line item by sending a PUT with the updated array excluding the item
        let updatedLineItems = currentLineItems.filter { $0.variantId != variantId }
        let request = DraftOrderRequestWrapper(draftOrder: DraftOrderRequest(
            id: draftOrderId,
            lineItems: updatedLineItems
        ))
        
        let response = try await networkService.updateDraftOrder(id: draftOrderId, request: request)
        return response.draftOrder
    }
    func deleteDraftOrder(draftOrderId: Int) async throws {
        try await networkService.deleteDraftOrder(id: draftOrderId)
    }
}
