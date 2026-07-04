//
//  CheckOutUseCaseProtocol.swift
//  shopify-ecommerce-ios
//
//  Created by Ehab Salah on 03/07/2026.
//

import Foundation

struct CheckoutUseCases {
    let createDraftOrder: CreateDraftOrderUseCase
    let updateDraftOrderLineItems: UpdateDraftOrderLineItemsUseCase
    let applyDiscount: ApplyDiscountUseCase
    let completeDraftOrder: CompleteDraftOrderUseCase
    let updateDraftOrderAddress: UpdateDraftOrderAddressUseCase
    let removeLineItem: RemoveLineItemUseCase
    let deleteDraftOrder: DeleteDraftOrderUseCase
}

