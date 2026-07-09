//
//  OrderDisplayModel.swift
//  shopify-ecommerce-ios
//
//  Created by Mahmoud Raafat Mustafa on 06/07/2026.
//

import Foundation
import SwiftUI

struct OrderDisplayModel: Identifiable, Hashable {
    let id: Int
    let orderName: String
    let formattedDate: String
    let status: OrderStatus
    let formattedTotal: String
    let formattedSubtotal: String
    let formattedTax: String
    let formattedDiscount: String?
    let rawTotal: String
    let rawSubtotal: String
    let rawTax: String
    let rawDiscount: String?
    let note: String?
    let lineItems: [OrderLineItemDisplay]
    let shippingAddress: OrderAddressDisplay?
    let billingAddress: OrderAddressDisplay?
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: OrderDisplayModel, rhs: OrderDisplayModel) -> Bool {
        lhs.id == rhs.id
    }
    
    init(from dto: OrderDTO) {
        self.id = dto.id
        self.orderName = dto.name
        self.formattedDate = OrderDisplayModel.formatDate(dto.createdAt)
        self.status = OrderDisplayModel.determineStatus(
            financial: dto.financialStatus,
            fulfillment: dto.fulfillmentStatus
        )
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = dto.currency
        
        self.formattedTotal = formatter.string(from: NSDecimalNumber(string: dto.totalPrice)) ?? dto.totalPrice
        self.formattedSubtotal = formatter.string(from: NSDecimalNumber(string: dto.subtotalPrice)) ?? dto.subtotalPrice
        self.formattedTax = formatter.string(from: NSDecimalNumber(string: dto.totalTax)) ?? dto.totalTax
        
        self.rawTotal = dto.totalPrice
        self.rawSubtotal = dto.subtotalPrice
        self.rawTax = dto.totalTax
        
        let discountValue = NSDecimalNumber(string: dto.totalDiscounts)
        if discountValue.compare(NSDecimalNumber.zero) == .orderedSame {
            self.formattedDiscount = nil
            self.rawDiscount = nil
        } else {
            self.formattedDiscount = formatter.string(from: discountValue) ?? dto.totalDiscounts
            self.rawDiscount = dto.totalDiscounts
        }
        
        self.note = dto.note
        self.lineItems = dto.lineItems.map { OrderLineItemDisplay(from: $0) }
        self.shippingAddress = dto.shippingAddress.map { OrderAddressDisplay(from: $0) }
        self.billingAddress = dto.billingAddress.map { OrderAddressDisplay(from: $0) }
    }
    
    private static func formatDate(_ dateString: String) -> String {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        
        guard let date = formatter.date(from: dateString) else {
            return dateString
        }
        
        let displayFormatter = DateFormatter()
        displayFormatter.dateStyle = .medium
        displayFormatter.timeStyle = .short
        return displayFormatter.string(from: date)
    }
    
    private static func determineStatus(financial: String?, fulfillment: String?) -> OrderStatus {
        guard let financial = financial?.lowercased() else {
            return .unknown
        }
        
        switch financial {
        case "pending":
            return .pending
        case "authorized":
            return .processing
        case "partially_paid":
            return .processing
        case "paid":
            if let fulfillment = fulfillment?.lowercased() {
                switch fulfillment {
                case "fulfilled":
                    return .fulfilled
                case "partial":
                    return .partial
                default:
                    return .processing
                }
            }
            return .processing
        case "refunded", "voided":
            return .cancelled
        default:
            return .unknown
        }
    }
}

