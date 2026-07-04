//
//  ShopifyCustomerRepositoryProtocol.swift
//  shopify-ecommerce-ios
//
//  Created by Mahmoud Raafat Mustafa on 03/07/2026.
//


protocol ShopifyCustomerRepositoryProtocol {
    func getCustomer(id: Int) async throws -> ShopifyCustomer
    func updateCustomerAddress(id: Int, address: ShopifyAddress) async throws -> ShopifyAddress
    func getMetafields(customerId: Int, namespace: String) async throws -> [Metafield]
       func createMetafield(customerId: Int, metafield: Metafield) async throws -> Metafield
       func updateMetafield(customerId: Int, metafieldId: Int, value: String) async throws -> Metafield
}
