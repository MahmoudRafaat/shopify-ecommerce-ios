import Foundation

protocol CheckoutRepository {
    func createDraftOrder(variantId: Int, quantity: Int) async throws -> DraftOrderResponse
    func updateDraftOrderLineItems(draftOrderId: Int, lineItems: [DraftLineItemRequest]) async throws -> DraftOrderResponse
    func applyDiscount(draftOrderId: Int, discount: DraftAppliedDiscountRequest) async throws -> DraftOrderResponse
}
