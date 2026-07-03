import Foundation

protocol CheckoutNetworkServiceProtocol {
    func createDraftOrder(request: DraftOrderRequestWrapper) async throws -> DraftOrderResponseWrapper
    func updateDraftOrder(id: Int, request: DraftOrderRequestWrapper) async throws -> DraftOrderResponseWrapper
}

final class CheckoutNetworkService: CheckoutNetworkServiceProtocol {
    func createDraftOrder(request: DraftOrderRequestWrapper) async throws -> DraftOrderResponseWrapper {
        return try await NetworkService.request(
            endpoint: CheckoutEndpoint.createDraftOrder,
            body: request
        )
    }
    
    func updateDraftOrder(id: Int, request: DraftOrderRequestWrapper) async throws -> DraftOrderResponseWrapper {
        return try await NetworkService.request(
            endpoint: CheckoutEndpoint.updateDraftOrder(id: id),
            body: request
        )
    }
}
