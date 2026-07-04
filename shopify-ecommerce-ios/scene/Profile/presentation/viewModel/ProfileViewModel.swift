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
        guard uiState.isNameValid else {
            uiState.errorMessage = "Please enter both first and last name"
            return
        }
        
        uiState.isSavingName = true
        uiState.errorMessage = nil
        
        do {
            try await updateProfileUseCase.updateName(
                customerId: customerId,
                firstName: uiState.firstName,
                lastName: uiState.lastName
            )
        } catch {
            uiState.errorMessage = "Failed to update name: \(error.localizedDescription)"
            await loadProfile() // Revert to previous state
        }
        
        uiState.isSavingName = false
    }
    
    @MainActor
    func saveEmail() async {
        guard let customerId = customerId else { return }
        guard uiState.isEmailValid else {
            uiState.errorMessage = "Please enter a valid email address"
            return
        }
        
        uiState.isSavingEmail = true
        uiState.errorMessage = nil
        
        do {
            try await updateProfileUseCase.updateEmail(
                customerId: customerId,
                email: uiState.email
            )
        } catch {
            uiState.errorMessage = "Failed to update email: \(error.localizedDescription)"
            await loadProfile()
        }
        
        uiState.isSavingEmail = false
    }
    
    @MainActor
    func saveAddress() async {
        guard let customerId = customerId else { return }
        guard uiState.isAddressValid else {
            uiState.errorMessage = "Please fill in all address fields"
            return
        }
        
        uiState.isSavingAddress = true
        uiState.errorMessage = nil
        
        let address = ProfileAddress(
            id: nil,
            address1: uiState.address1,
            city: uiState.city,
            province: uiState.province,
            country: uiState.country,
            zip: uiState.zip,
            phone: uiState.phone.isEmpty ? nil : uiState.phone,
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
        } catch {
            uiState.errorMessage = "Failed to update address: \(error.localizedDescription)"
        }
        
        uiState.isSavingAddress = false
    }
    
    @MainActor
    func savePaymentDetails() async {
        guard let customerId = customerId else { return }
        guard uiState.isPaymentValid else {
            uiState.errorMessage = "Please fill in all payment fields"
            return
        }
        
        uiState.isSavingPayment = true
        uiState.errorMessage = nil
        
        let paymentDetails = PaymentDetails(
            cardholderName: uiState.cardholderName,
            cardNumber: uiState.cardNumber,
            expiryMonth: uiState.expiryMonth,
            expiryYear: uiState.expiryYear,
            cvv: uiState.cvv,
            isDefault: true
        )
        
        do {
            try await updateProfileUseCase.updatePaymentDetails(
                customerId: customerId,
                paymentDetails: paymentDetails
            )
            uiState.hasPaymentDetails = true
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
    }
    
    private func updateAddressUI(with address: ProfileAddress) {
        uiState.address1 = address.address1
        uiState.city = address.city
        uiState.province = address.province
        uiState.country = address.country
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
}