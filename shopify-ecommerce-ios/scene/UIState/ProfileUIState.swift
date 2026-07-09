//
//  ProfileUIState.swift
//  shopify-ecommerce-ios
//
//  Created by Mahmoud Raafat Mustafa on 02/07/2026.
//

import Foundation

struct ProfileUIState {
    var email: String = ""
    var firstName: String = ""
    var lastName: String = ""
    
    var address1: String = ""
    var city: String = ""
    
    var province: String = ""
    var country: String = ""
    
    var provinceCode: String = ""
    var countryCode: String = ""
    
    var zip: String = ""
    var phone: String = ""
    
    var cardholderName: String = ""
    var cardNumber: String = ""
    var expiryMonth: String = ""
    var expiryYear: String = ""
    var cvv: String = ""
    
    var isLoggedIn: Bool = false
    var hasAddress: Bool = false
    var hasPaymentDetails: Bool = false
    var isLoading: Bool = false
    var isSavingName: Bool = false
    var isSavingAddress: Bool = false
    var isSavingPayment: Bool = false
    var errorMessage: String? = nil
    
    var isNameValid: Bool {
        !firstName.isEmpty && !lastName.isEmpty
    }
    
    var isAddressValid: Bool {
        !address1.isEmpty && !city.isEmpty && !provinceCode.isEmpty && !countryCode.isEmpty && !zip.isEmpty
    }
    
    var isPaymentValid: Bool {
        !cardholderName.isEmpty &&
        cardNumber.count >= 4 &&
        !expiryMonth.isEmpty &&
        !expiryYear.isEmpty &&
        !cvv.isEmpty
    }
}
