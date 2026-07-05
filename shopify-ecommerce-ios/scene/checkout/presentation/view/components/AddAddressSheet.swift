//
//  AddAddressSheet.swift
//  shopify-ecommerce-ios
//
//  Created by Ehab Salah on 04/07/2026.
//



import SwiftUI

struct AddAddressSheet: View {
    @Environment(CheckoutViewModel.self) var viewModel
    @Environment(\.presentationMode) var presentationMode
    
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var address1: String = ""
    @State private var city: String = ""
    @State private var country: String = ""
    @State private var phone: String = ""
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    AddressPersonalDetailsSection(
                        firstName: $firstName,
                        lastName: $lastName,
                        phone: $phone
                    )
                    
                    AddressDetailsSection(
                        address1: $address1,
                        city: $city,
                        country: $country
                    )
                    
                    CustomButton(text: "Save Address") {
                        Task {
                            let newAddress = DraftAddressRequest(
                                firstName: firstName,
                                lastName: lastName,
                                address1: address1,
                                city: city,
                                country: country,
                                phone: phone
                            )
                            await viewModel.updateAddress(address: newAddress)
                            viewModel.isAddressSheetPresented = false
                        }
                    }
                    .disabled(address1.isEmpty || city.isEmpty || country.isEmpty)
                    .padding(.horizontal, 28)
                    .padding(.top, 32)
                    .padding(.bottom, 20)
                    .opacity((address1.isEmpty || city.isEmpty || country.isEmpty) ? 0.5 : 1.0)
                }
            }
            .background(Color(white: 0.98)) // Slight off-white to match the CustomTextField styling
            .navigationTitle("Shipping Address")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        viewModel.isAddressSheetPresented = false
                    }
                }
            }
            .onAppear {
                if let current = viewModel.currentAddress {
                    firstName = current.firstName ?? ""
                    lastName = current.lastName ?? ""
                    address1 = current.address1 ?? ""
                    city = current.city ?? ""
                    country = current.country ?? ""
                    phone = current.phone ?? ""
                }
            }
        }
    }
}

#Preview {
    AddAddressSheet()
        .environment(CheckoutViewModel())
}
