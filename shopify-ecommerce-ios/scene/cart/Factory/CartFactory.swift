//
//  CartFactory.swift
//  shopify-ecommerce-ios
//
//  Created on 08/07/2026.
//

import Foundation

@MainActor
final class CartFactory {
    static func makeCartViewModel() -> CartViewModel {
        
        // MARK: Data layer
        let checkoutRepository = CheckoutRepositoryImpl()
        
        // MARK: Use cases
        let useCases = CheckoutUseCases(
            createDraftOrder: CreateDraftOrderUseCaseImpl(repository: checkoutRepository),
            getDraftOrder: GetDraftOrderUseCaseImpl(repository: checkoutRepository),
            getCustomerCartMetafield: GetCustomerCartMetafieldUseCaseImpl(repository: checkoutRepository),
            setCustomerCartMetafield: SetCustomerCartMetafieldUseCaseImpl(repository: checkoutRepository),
            updateDraftOrderLineItems: UpdateDraftOrderLineItemsUseCaseImpl(repository: checkoutRepository),
            applyDiscount: ApplyDiscountUseCaseImpl(repository: checkoutRepository),
            completeDraftOrder: CompleteDraftOrderUseCaseImpl(repository: checkoutRepository),
            updateDraftOrderAddress: UpdateDraftOrderAddressUseCaseImpl(repository: checkoutRepository),
            removeLineItem: RemoveLineItemUseCaseImpl(repository: checkoutRepository),
            deleteDraftOrder: DeleteDraftOrderUseCaseImpl(repository: checkoutRepository),
            fetchActiveDiscountCodes: FetchActiveDiscountCodesUseCaseImpl(repository: checkoutRepository),
            removeDiscount: RemoveDiscountUseCaseImpl(repository: checkoutRepository)
        )
        
        // MARK: ViewModel
        return CartViewModel(useCases: useCases)
    }
}
