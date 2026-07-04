//
//  ProfileEndpoint.swift
//  shopify-ecommerce-ios
//
//  Created by Mahmoud Raafat Mustafa on 04/07/2026.
//

import Foundation
import Alamofire

enum ProfileEndpoint: ApiEndpoint {
    // Customer endpoints
    case getCustomer(id: Int)
    case updateCustomer(id: Int, address: ProfileAddress)
    
    // Metafield endpoints
    case getMetafields(customerId: Int)
    case createMetafield(customerId: Int, namespace: String, key: String, value: String, type: String)
    case updateMetafield(customerId: Int, metafieldId: Int, value: String)
    
    var path: String {
        switch self {
        case .getCustomer(let id):
            return "customers/\(id).json"
        case .updateCustomer(let id, _):
            return "customers/\(id).json"
        case .getMetafields(let customerId):
            return "customers/\(customerId)/metafields.json?namespace=custom"
        case .createMetafield(let customerId, _, _, _, _):
            return "customers/\(customerId)/metafields.json"
        case .updateMetafield(let customerId, let metafieldId, _):
            return "customers/\(customerId)/metafields/\(metafieldId).json"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getCustomer, .getMetafields:
            return .get
        case .updateCustomer, .updateMetafield:
            return .put
        case .createMetafield:
            return .post
        }
    }
    
    var body: Data? {
        switch self {
        case .getCustomer, .getMetafields:
            return nil
            
        case .updateCustomer(_, let address):
            let request = UpdateCustomerRequest(
                customer: UpdateCustomerRequest.Customer(
                    addresses: [
                        UpdateCustomerRequest.Address(
                            id: address.id,
                            address1: address.address1,
                            city: address.city,
                            province: address.province,
                            country: address.country,
                            zip: address.zip,
                            phone: address.phone,
                            firstName: address.firstName ?? "",
                            lastName: address.lastName ?? "",
                            isDefault: true
                        )
                    ]
                )
            )
            return encode(request)
            
        case .createMetafield(_, let namespace, let key, let value, let type):
            let request = CreateMetafieldRequest(
                metafield: MetafieldRequest(
                    namespace: namespace,
                    key: key,
                    value: value,
                    type: type
                )
            )
            return encode(request)
            
        case .updateMetafield(_, _, let value):
            let request = UpdateMetafieldRequest(
                metafield: MetafieldRequest(
                    namespace: "custom",
                    key: "",
                    value: value,
                    type: ""
                )
            )
            return encode(request)
        }
    }
    
    private func encode<T: Encodable>(_ value: T) -> Data? {
        do {
            let encoder = JSONEncoder()
            encoder.keyEncodingStrategy = .convertToSnakeCase
            return try encoder.encode(value)
        } catch {
            print("Encoding error: \(error)")
            return nil
        }
    }
}


