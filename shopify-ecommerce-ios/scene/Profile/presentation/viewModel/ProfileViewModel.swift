//
//  ProfileViewModel.swift
//  shopify-ecommerce-ios
//
//  Created by Mahmoud Raafat Mustafa on 04/07/2026.
//

import Foundation
import Observation

@Observable
class ProfileViewModel {
    
    private let getProfileUseCase: GetProfileUseCaseProtocol
    private let updateProfileUseCase: UpdateProfileUseCaseProtocol
    private let userDefaults: UserDefaults
    
    var uiState = ProfileUIState()
    private(set) var customerId: Int?
    
    var tempFirstName: String = ""
    var tempLastName: String = ""
    var tempAddress1: String = ""
    var tempCity: String = ""
    var tempProvince: String = ""
    var tempCountry: String = ""
    var tempZip: String = ""
    var tempPhone: String = ""
    var tempCardholderName: String = ""
    var tempCardNumber: String = ""
    var tempExpiryMonth: String = ""
    var tempExpiryYear: String = ""
    var tempCvv: String = ""
    
    init(
        getProfileUseCase: GetProfileUseCaseProtocol = ProfileUseCase(),
        updateProfileUseCase: UpdateProfileUseCaseProtocol = ProfileUseCase(),
        userDefaults: UserDefaults = .standard
    ) {
        self.getProfileUseCase = getProfileUseCase
        self.updateProfileUseCase = updateProfileUseCase
        self.userDefaults = userDefaults
        setupGuestState()
    }
    
    private func setupGuestState() {
        let isLoggedIn = userDefaults.bool(forKey: AppConstants.isLoggedIn)
        uiState.isLoggedIn = isLoggedIn
        
        if isLoggedIn {
            customerId = userDefaults.integer(forKey: AppConstants.customerId)
            if customerId == 0 {
                customerId = nil
                uiState.isLoggedIn = false
            }
        }
    }
    
    @MainActor
    func loadProfile() async {
        guard let customerId = customerId else {
            uiState.isLoading = false
            return
        }
        
        uiState.isLoading = true
        uiState.errorMessage = nil
        
        do {
            let profile = try await getProfileUseCase.execute(customerId: customerId)
            updateUIState(with: profile)
        } catch {
            uiState.errorMessage = error.localizedDescription
        }
        
        uiState.isLoading = false
    }
    
    @MainActor
    func saveName() async {
        guard let customerId = customerId else { return }
        
        let firstName = tempFirstName
        let lastName = tempLastName
        
        guard !firstName.isEmpty && !lastName.isEmpty else {
            uiState.errorMessage = "Please enter both first and last name"
            return
        }
        
        uiState.isSavingName = true
        uiState.errorMessage = nil
        
        do {
            try await updateProfileUseCase.updateName(
                customerId: customerId,
                firstName: firstName,
                lastName: lastName
            )
            uiState.firstName = firstName
            uiState.lastName = lastName
            syncTempValues()
        } catch {
            uiState.errorMessage = "Failed to update name: \(error.localizedDescription)"
            await loadProfile()
        }
        
        uiState.isSavingName = false
    }
    
    @MainActor
    func saveAddress() async {
        guard let customerId = customerId else { return }
        
        let address1 = tempAddress1
        let city = tempCity
        let provinceCode = tempProvince
        let countryCode = tempCountry
        let zip = tempZip
        let phone = tempPhone
        
        guard !address1.isEmpty && !city.isEmpty && !provinceCode.isEmpty && !countryCode.isEmpty && !zip.isEmpty else {
            uiState.errorMessage = "Please fill in all address fields"
            return
        }
        
        uiState.isSavingAddress = true
        uiState.errorMessage = nil
    
        let address = ProfileAddress(
            id: nil,
            address1: address1,
            city: city,
            province: provinceCode,
            provinceCode: provinceCode,
            country: countryCode,
            countryCode: countryCode,
            zip: zip,
            phone: phone.isEmpty ? nil : phone,
            firstName: uiState.firstName,
            lastName: uiState.lastName,
            isDefault: true
        )
        
        do {
            let updatedAddress = try await updateProfileUseCase.updateAddress(
                customerId: customerId,
                address: address
            )
            updateAddressUI(with: updatedAddress)
            uiState.hasAddress = true
            syncTempValues()
        } catch {
            uiState.errorMessage = "Failed to update address: \(error.localizedDescription)"
        }
        
        uiState.isSavingAddress = false
    }
    @MainActor
    func savePaymentDetails() async {
        guard let customerId = customerId else { return }
        
        let cardholderName = tempCardholderName
        let cardNumber = tempCardNumber
        let expiryMonth = tempExpiryMonth
        let expiryYear = tempExpiryYear
        let cvv = tempCvv
        
        guard !cardholderName.isEmpty && cardNumber.count >= 4 && !expiryMonth.isEmpty && !expiryYear.isEmpty && !cvv.isEmpty else {
            uiState.errorMessage = "Please fill in all payment fields"
            return
        }
        
        uiState.isSavingPayment = true
        uiState.errorMessage = nil
        
        let paymentDetails = PaymentDetails(
            cardholderName: cardholderName,
            cardNumber: cardNumber,
            expiryMonth: expiryMonth,
            expiryYear: expiryYear,
            cvv: cvv,
            isDefault: true
        )
        
        do {
            try await updateProfileUseCase.updatePaymentDetails(
                customerId: customerId,
                paymentDetails: paymentDetails
            )
            uiState.cardholderName = cardholderName
            uiState.cardNumber = cardNumber
            uiState.expiryMonth = expiryMonth
            uiState.expiryYear = expiryYear
            uiState.cvv = cvv
            uiState.hasPaymentDetails = true
            syncTempValues()
        } catch {
            uiState.errorMessage = "Failed to update payment details: \(error.localizedDescription)"
        }
        
        uiState.isSavingPayment = false
    }
    
    // MARK: - Private Helpers
    
    private func updateUIState(with profile: ProfileDisplayModel) {
        uiState.email = profile.email
        uiState.firstName = profile.firstName
        uiState.lastName = profile.lastName
        
        if let address = profile.address {
            updateAddressUI(with: address)
        } else {
            uiState.hasAddress = false
        }
        
        if let payment = profile.paymentDetails {
            updatePaymentUI(with: payment)
        } else {
            uiState.hasPaymentDetails = false
        }
        
        syncTempValues()
    }
    
    private func updateAddressUI(with address: ProfileAddress) {
        uiState.province = address.province
            uiState.country = address.country
            uiState.provinceCode = address.provinceCode
            uiState.countryCode = address.countryCode
        uiState.address1 = address.address1
        uiState.city = address.city
        uiState.zip = address.zip
        uiState.phone = address.phone ?? ""
        uiState.hasAddress = true
    }
    
    private func updatePaymentUI(with payment: PaymentDetails) {
        uiState.cardholderName = payment.cardholderName
        uiState.cardNumber = payment.cardNumber
        uiState.expiryMonth = payment.expiryMonth
        uiState.expiryYear = payment.expiryYear
        uiState.cvv = payment.cvv
        uiState.hasPaymentDetails = true
    }
    
    private func syncTempValues() {
        tempFirstName = uiState.firstName
        tempLastName = uiState.lastName
        tempAddress1 = uiState.address1
        tempCity = uiState.city
        tempProvince = uiState.provinceCode
        tempCountry = uiState.countryCode
        tempZip = uiState.zip
        tempPhone = uiState.phone
        tempCardholderName = uiState.cardholderName
        tempCardNumber = uiState.cardNumber
        tempExpiryMonth = uiState.expiryMonth
        tempExpiryYear = uiState.expiryYear
        tempCvv = uiState.cvv
    }
}
