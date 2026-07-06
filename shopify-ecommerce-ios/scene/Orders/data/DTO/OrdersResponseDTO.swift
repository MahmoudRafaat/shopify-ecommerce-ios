//
//  OrdersResponseDTO.swift
//  shopify-ecommerce-ios
//
//  Created by Mahmoud Raafat Mustafa on 06/07/2026.
//


import Foundation

struct OrdersResponseDTO: Codable {
    let orders: [OrderDTO]
}

struct OrderDTO: Codable {
    let id: Int
    let name: String
    let orderNumber: Int
    let createdAt: String
    let currency: String
    let financialStatus: String?
    let fulfillmentStatus: String?
    let totalPrice: String
    let subtotalPrice: String
    let totalTax: String
    let totalDiscounts: String
    let note: String?
    let lineItems: [OrderLineItemDTO]
    let shippingAddress: OrderAddressDTO?
    let billingAddress: OrderAddressDTO?
    
    enum CodingKeys: String, CodingKey {
        case id, name, currency, note
        case orderNumber = "order_number"
        case createdAt = "created_at"
        case financialStatus = "financial_status"
        case fulfillmentStatus = "fulfillment_status"
        case totalPrice = "total_price"
        case subtotalPrice = "subtotal_price"
        case totalTax = "total_tax"
        case totalDiscounts = "total_discounts"
        case lineItems = "line_items"
        case shippingAddress = "shipping_address"
        case billingAddress = "billing_address"
    }
}

struct OrderLineItemDTO: Codable {
    let id: Int
    let title: String
    let quantity: Int
    let price: String
    let sku: String?
    let vendor: String?
    let variantTitle: String?
    
    enum CodingKeys: String, CodingKey {
        case id, title, quantity, price, sku, vendor
        case variantTitle = "variant_title"
    }
}

struct OrderAddressDTO: Codable {
    let address1: String?
    let address2: String?
    let city: String?
    let province: String?
    let provinceCode: String?
    let country: String?
    let countryCode: String?
    let zip: String?
    let firstName: String?
    let lastName: String?
    let phone: String?
    
    enum CodingKeys: String, CodingKey {
        case address1, address2, city, province, country, zip, phone
        case provinceCode = "province_code"
        case countryCode = "country_code"
        case firstName = "first_name"
        case lastName = "last_name"
    }
}
