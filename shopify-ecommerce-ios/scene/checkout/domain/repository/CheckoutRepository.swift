import Foundation

protocol CheckoutRepository {
    func createDraftOrder(lineItems: [DraftLineItemRequest]) async throws -> DraftOrderResponse
    func updateDraftOrderLineItems(draftOrderId: Int, lineItems: [DraftLineItemRequest]) async throws -> DraftOrderResponse
    func applyDiscount(draftOrderId: Int, discount: DraftAppliedDiscountRequest) async throws -> DraftOrderResponse
    func completeDraftOrder(draftOrderId: Int) async throws -> DraftOrderResponse
}
