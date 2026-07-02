//
//  CheckoutUIState.swift
//  shopify-ecommerce-ios
//
//  Created by Mahmoud Raafat Mustafa on 02/07/2026.
//



import Foundation

struct CheckoutUIState {
    // Read-only fields (from user auth profile)
    var email: String = ""
    
    // Editable fields
    var name: String = ""
    var pincode: String = ""
    var address: String = ""
    var city: String = ""
    var country: String = ""
    var bankAccountNumber: String = ""
    var ifscCode: String = ""
    
    var isLoading: Bool = false
    var errorMessage: String? = nil
    
    // Validation computed property
    var isFormValid: Bool {
        return !pincode.isEmpty &&
               !address.isEmpty &&
               !city.isEmpty &&
               !bankAccountNumber.isEmpty &&
               !ifscCode.isEmpty &&
               !name.isEmpty
    }
}
