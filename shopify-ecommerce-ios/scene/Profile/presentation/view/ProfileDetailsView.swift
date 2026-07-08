//
//  ProfileDetailsView.swift
//  shopify-ecommerce-ios
//
//  Created by Mahmoud Raafat Mustafa on 04/07/2026.
//

import SwiftUI

struct ProfileDetailsView: View {
    
    @State private var viewModel: ProfileViewModel
    @State private var isEditingName = false
    @State private var isEditingAddress = false
    @State private var isEditingPayment = false
    @State private var showLoginScreen = false
    
    let brandRed = Color(red: 0.95, green: 0.25, blue: 0.40)
    
    init(viewModel: ProfileViewModel) {
        self._viewModel = State(initialValue: viewModel)
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    
                    if !viewModel.uiState.isLoggedIn {
                        GuestModeBanner(
                            brandColor: brandRed,
                            onSignIn: {
                                showLoginScreen = true
                            }
                        )
                    }
                    
                    ProfilePhotoEditView()
                        .padding(.top, 16)
                    
                    PersonalDetailsSection(
                        uiState: viewModel.uiState,
                        isEditingName: $isEditingName,
                        
                        tempFirstName: $viewModel.tempFirstName,
                        tempLastName: $viewModel.tempLastName,
                        brandColor: brandRed,
                        onSaveName: {
                            Task { await viewModel.saveName() }
                            isEditingName = false
                        }
                    )
                    
                    Divider().padding(.horizontal, 28)
                    
                    AddressProfileSection(
                        uiState: viewModel.uiState,
                        isEditing: $isEditingAddress,
                        tempAddress1: $viewModel.tempAddress1,
                        tempCity: $viewModel.tempCity,
                        tempProvince: $viewModel.tempProvince,
                        tempCountry: $viewModel.tempCountry,
                        tempZip: $viewModel.tempZip,
                        tempPhone: $viewModel.tempPhone,
                        brandColor: brandRed,
                        onSave: {
                            Task { await viewModel.saveAddress() }
                            isEditingAddress = false
                        }
                    )
                    
                    Divider().padding(.horizontal, 28)
                    
                    PaymentDetailsSection(
                        uiState: viewModel.uiState,
                        isEditing: $isEditingPayment,
                        tempCardholderName: $viewModel.tempCardholderName,
                        tempCardNumber: $viewModel.tempCardNumber,
                        tempExpiryMonth: $viewModel.tempExpiryMonth,
                        tempExpiryYear: $viewModel.tempExpiryYear,
                        tempCvv: $viewModel.tempCvv,
                        brandColor: brandRed,
                        onSave: {
                            Task { await viewModel.savePaymentDetails() }
                            isEditingPayment = false
                        }
                    )
                    
                    Spacer(minLength: 40)
                }
            }
            .background(Color(white: 0.99))
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.inline)
            .showCustomAlert(title: "Error", errorMessage: $viewModel.uiState.errorMessage)
            .showLoading(if: viewModel.uiState.isLoading)
            .onAppear {
                if viewModel.uiState.isLoggedIn {
                    Task { await viewModel.loadProfile() }
                }
            }
        }
        .fullScreenCover(isPresented: $showLoginScreen) {
            LoginView(viewmodel: AuthFactory.makeLoginViewModel())
        }
        .onChange(of: showLoginScreen) { _, newValue in
            if !newValue && viewModel.uiState.isLoggedIn {
                Task { await viewModel.loadProfile() }
            }
        }
    }
}




