import Foundation

protocol CheckoutNetworkServiceProtocol {
    func createDraftOrder(request: DraftOrderRequestWrapper) async throws -> DraftOrderResponseWrapper
    func updateDraftOrder(id: Int, request: DraftOrderRequestWrapper) async throws -> DraftOrderResponseWrapper
    func completeDraftOrder(id: Int) async throws -> DraftOrderResponseWrapper
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
    
    func completeDraftOrder(id: Int) async throws -> DraftOrderResponseWrapper {
        // Explicitly casting nil to Alamofire.Empty? to satisfy the compiler for the generic Body parameter
        return try await NetworkService.request(
            endpoint: CheckoutEndpoint.completeDraftOrder(id: id),
            body: nil as Alamofire.Empty?
        )
    }
}
