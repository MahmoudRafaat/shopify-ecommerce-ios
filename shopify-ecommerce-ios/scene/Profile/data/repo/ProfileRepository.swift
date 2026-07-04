//
//  ProfileRepository.swift
//  shopify-ecommerce-ios
//
//  Created by Mahmoud Raafat Mustafa on 02/07/2026.
//

import Foundation
import FirebaseAuth

class ProfileRepository: ProfileRepositoryProtocol {
    
    private let networkService: NetworkService.Type
    private let auth: Auth
    
    init(
        networkService: NetworkService.Type = NetworkService.self,
        auth: Auth = Auth.auth()
    ) {
        self.networkService = networkService
        self.auth = auth
    }
    
    
    func getProfile(customerId: Int) async throws -> ProfileDisplayModel {
        async let customer = getCustomer(id: customerId)
        async let metafields = getMetafields(customerId: customerId)
        
        let (customerResult, metafieldsResult) = try await (customer, metafields)
        
        let email = getCurrentUserEmail()
        
        let firstName = getMetafieldValue(metafields: metafieldsResult, key: "first_name") ?? ""
        let lastName = getMetafieldValue(metafields: metafieldsResult, key: "last_name") ?? ""
        let paymentDetails = getPaymentDetails(metafields: metafieldsResult)
        let address = customerResult.defaultAddress.map { ProfileAddress(from: $0) }
        
        return ProfileDisplayModel(
            email: email,
            firstName: firstName,
            lastName: lastName,
            address: address,
            paymentDetails: paymentDetails
        )
    }
    
    
    private func getCurrentUserEmail() -> String {
        return auth.currentUser?.email ?? ""
    }
    
    
    private func getCustomer(id: Int) async throws -> CustomerDTO {
        let endpoint = ProfileEndpoint.getCustomer(id: id)
        let response: CustomerResponseDTO = try await networkService.request(endpoint: endpoint)
        print("🟢 GET CUSTOMER RESPONSE:", response)
        return response.customer
    }
    
    private func getMetafields(customerId: Int) async throws -> [MetafieldDTO] {
        let endpoint = ProfileEndpoint.getMetafields(customerId: customerId)
        let response: MetafieldsResponse = try await networkService.request(endpoint: endpoint)
        
        return response.metafields
    }
    
    private func getMetafieldValue(metafields: [MetafieldDTO], key: String) -> String? {
        return metafields.first { $0.key == key }?.value
    }
    
    private func getPaymentDetails(metafields: [MetafieldDTO]) -> PaymentDetails? {
        guard let jsonString = getMetafieldValue(metafields: metafields, key: "payment_details"),
              let data = jsonString.data(using: .utf8) else {
            return nil
        }
        
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return try decoder.decode(PaymentDetails.self, from: data)
        } catch {
            print("Failed to decode payment details: \(error)")
            return nil
        }
    }
    
    private func setMetafield(customerId: Int, key: String, value: String, type: String) async throws {
        let existing = try await getMetafields(customerId: customerId)
        let existingMetafield = existing.first { $0.key == key }
        
        if let existingId = existingMetafield?.id {
            let endpoint = ProfileEndpoint.updateMetafield(
                customerId: customerId,
                metafieldId: existingId,
                value: value
            )
            _ = try await networkService.request(endpoint: endpoint) as MetafieldResponse
        } else {
            let endpoint = ProfileEndpoint.createMetafield(
                customerId: customerId,
                namespace: "custom",
                key: key,
                value: value,
                type: type
            )
            _ = try await networkService.request(endpoint: endpoint) as MetafieldResponse
        }
    }
    
    private func encodePaymentDetails(_ details: PaymentDetails) -> String? {
        do {
            let encoder = JSONEncoder()
            encoder.keyEncodingStrategy = .convertToSnakeCase
            let data = try encoder.encode(details)
            return String(data: data, encoding: .utf8)
        } catch {
            print("Failed to encode payment details: \(error)")
            return nil
        }
    }
}


extension ProfileRepository {
    
    func updateName(customerId: Int, firstName: String, lastName: String) async throws {
        try await setMetafield(customerId: customerId, key: "first_name", value: firstName, type: "single_line_text_field")
        try await setMetafield(customerId: customerId, key: "last_name", value: lastName, type: "single_line_text_field")
    }
    
    func updateAddress(customerId: Int, address: ProfileAddress) async throws -> ProfileAddress {
        let endpoint = ProfileEndpoint.updateCustomer(id: customerId, address: address)
        let response: CustomerResponseDTO = try await networkService.request(endpoint: endpoint)
        print("🟢 GET CUSTOMER RESPONSE:", response)
        guard let defaultAddress = response.customer.defaultAddress else {
            throw NetworkError.unknown(0)
        }
        
        return ProfileAddress(from: defaultAddress)
    }
    
    func updatePaymentDetails(customerId: Int, paymentDetails: PaymentDetails) async throws {
        guard let encodedValue = encodePaymentDetails(paymentDetails) else {
            throw NetworkError.unknown(0)
        }
        
        try await setMetafield(
            customerId: customerId,
            key: "payment_details",
            value: encodedValue,
            type: "json"
        )
    }
}
