//
//  ProfileRepository.swift
//  shopify-ecommerce-ios
//
//  Created by Mahmoud Raafat Mustafa on 02/07/2026.
//

import Foundation
import FirebaseAuth

protocol ProfileRepositoryProtocol {
    func getProfile(customerId: Int) async throws -> ProfileDisplayModel
    func updateName(customerId: Int, firstName: String, lastName: String) async throws
    func updateAddress(customerId: Int, address: ProfileAddress) async throws -> ProfileAddress
    func updatePaymentDetails(customerId: Int, paymentDetails: PaymentDetails) async throws
}
