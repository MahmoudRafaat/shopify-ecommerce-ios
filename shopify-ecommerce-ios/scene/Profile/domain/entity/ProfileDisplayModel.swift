//
//  ProfileDisplayModel.swift
//  shopify-ecommerce-ios
//
//  Created by Mahmoud Raafat Mustafa on 04/07/2026.
//



struct ProfileDisplayModel {
    let email: String
    var firstName: String
    var lastName: String
    var address: ProfileAddress?
    var paymentDetails: PaymentDetails?
    
    var hasDefaultAddress: Bool { address != nil }
    var hasPaymentDetails: Bool { paymentDetails != nil }
}
