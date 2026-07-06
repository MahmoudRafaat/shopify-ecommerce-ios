import Foundation

protocol CheckoutNetworkServiceProtocol {
    func createDraftOrder(request: DraftOrderRequestWrapper) async throws -> DraftOrderResponseWrapper
    func updateDraftOrder(id: Int, request: DraftOrderRequestWrapper) async throws -> DraftOrderResponseWrapper
    func completeDraftOrder(id: Int) async throws -> DraftOrderResponseWrapper
    func deleteDraftOrder(id: Int) async throws
    func getDraftOrder(id: Int) async throws -> DraftOrderResponseWrapper
    func removeDiscount(id: Int) async throws -> DraftOrderResponseWrapper
    func getPriceRules() async throws -> PriceRulesResponseWrapper
    func getDiscountCodes(priceRuleId: Int) async throws -> DiscountCodesResponseWrapper
    func getCustomerMetafields(customerId: Int) async throws -> MetafieldsResponseWrapper
    func createCustomerMetafield(customerId: Int, request: MetafieldRequestWrapper) async throws -> SingleMetafieldResponseWrapper
    func updateCustomerMetafield(customerId: Int, metafieldId: Int, request: MetafieldRequestWrapper) async throws -> SingleMetafieldResponseWrapper
}

final class CheckoutNetworkService: CheckoutNetworkServiceProtocol {
    func createDraftOrder(request: DraftOrderRequestWrapper) async throws -> DraftOrderResponseWrapper {
        return try await NetworkService.request(
            endpoint: CheckoutEndpoint.createDraftOrder(request: request)
        )
    }
    
    func updateDraftOrder(id: Int, request: DraftOrderRequestWrapper) async throws -> DraftOrderResponseWrapper {
        return try await NetworkService.request(
            endpoint: CheckoutEndpoint.updateDraftOrder(id: id, request: request)
        )
    }
    
    func completeDraftOrder(id: Int) async throws -> DraftOrderResponseWrapper {
        return try await NetworkService.request(
            endpoint: CheckoutEndpoint.completeDraftOrder(id: id)
        )
    }
    
    func deleteDraftOrder(id: Int) async throws {
        let _: EmptyResponse = try await NetworkService.request(
            endpoint: CheckoutEndpoint.deleteDraftOrder(id: id)
        )
    }
    
    func getDraftOrder(id: Int) async throws -> DraftOrderResponseWrapper {
        return try await NetworkService.request(
            endpoint: CheckoutEndpoint.getDraftOrder(id: id)
        )
    }
    
    func removeDiscount(id: Int) async throws -> DraftOrderResponseWrapper {
        return try await NetworkService.request(
            endpoint: CheckoutEndpoint.removeDiscount(id: id)
        )
    }
    
    func getPriceRules() async throws -> PriceRulesResponseWrapper {
        return try await NetworkService.request(
            endpoint: CheckoutEndpoint.getPriceRules
        )
    }
    
    func getDiscountCodes(priceRuleId: Int) async throws -> DiscountCodesResponseWrapper {
        return try await NetworkService.request(
            endpoint: CheckoutEndpoint.getDiscountCodes(priceRuleId: priceRuleId)
        )
    }
    
    func getCustomerMetafields(customerId: Int) async throws -> MetafieldsResponseWrapper {
        return try await NetworkService.request(
            endpoint: CheckoutEndpoint.getCustomerMetafields(customerId: customerId)
        )
    }
    
    func createCustomerMetafield(customerId: Int, request: MetafieldRequestWrapper) async throws -> SingleMetafieldResponseWrapper {
        return try await NetworkService.request(
            endpoint: CheckoutEndpoint.createCustomerMetafield(customerId: customerId, request: request)
        )
    }
    
    func updateCustomerMetafield(customerId: Int, metafieldId: Int, request: MetafieldRequestWrapper) async throws -> SingleMetafieldResponseWrapper {
        return try await NetworkService.request(
            endpoint: CheckoutEndpoint.updateCustomerMetafield(customerId: customerId, metafieldId: metafieldId, request: request)
        )
    }
}

// bec APi doesn't return anything on delete
struct EmptyResponse: Decodable {}
