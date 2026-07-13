//
//  CartUIState.swift
//  shopify-ecommerce-ios
//
//  Created by albaraa alsayed on 24/01/1448 AH.
//

import Foundation

struct CartUIState {
    var isLoading = false
    var error: AppError? = nil
    
    var draftOrderId: Int?
    var orderTotal: String = "0.00"
    var subtotal: String = "0.00"
    var originalSubtotal: String = "0.00"
    var tax: String = "0.00"
    var discountAmount: String = "0.00"
    
    var cartLineItems: [OrderItemUIModel] = []
    var discountCode: String = ""
    var currentAddress: DraftAddressRequest? = nil
    var isAddressSheetPresented: Bool = false
    var isOrderDeleted: Bool = false
    
    var activeCoupons: [String: PriceRuleResponse] = [:]
    var isCouponSheetPresented: Bool = false
    var selectedCoupon: PriceRuleResponse?
    var selectedCouponCode: String?
}
