//
//  FilterSheetView.swift
//  shopify-ecommerce-ios
//
//  Created by albaraa alsayed on 20/01/1448 AH.
//

import SwiftUI

struct FilterSheetView: View {
    var currentVendor: String
    var currentCollectionId: Int?
    var availableVendors: [SearchVendor]
    var availableCategories: [SearchCategory]
    
    var onApply: (_ vendor: String, _ collectionId: Int?) -> Void
    var onClear: () -> Void
    var onDismiss: () -> Void
    
    @State private var selectedVendor: String = ""
    @State private var selectedCollectionId: Int? = nil
    
    private var hasActiveFilters: Bool {
        return !selectedVendor.isEmpty || selectedCollectionId != nil
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Brand") {
                    Picker("Select Brand", selection: $selectedVendor) {
                        Text("All Brands").tag("")
                        ForEach(availableVendors, id: \.id) { vendor in
                            Text(vendor.title).tag(vendor.title)
                        }
                    }
                    .pickerStyle(.navigationLink)
                }
                
                Section("Category") {
                    Picker("Select Category", selection: $selectedCollectionId) {
                        Text("All Categories").tag(Int?.none)
                        ForEach(availableCategories, id: \.id) { category in
                            Text(category.title).tag(Int?.some(category.id))
                        }
                    }
                    .pickerStyle(.navigationLink)
                }
                
                if hasActiveFilters {
                    Section {
                        Button(role: .destructive) {
                            selectedVendor = ""
                            selectedCollectionId = nil
                            onClear()
                        } label: {
                            Text("Clear All Filters")
                        }
                    }
                }
            }
            .navigationTitle("Filter")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") { onDismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Apply") {
                        onApply(selectedVendor, selectedCollectionId)
                    }
                    .fontWeight(.semibold)
                }
            }
        }
        .background(AppColor.backgroundPrimary)
        .presentationDetents([.medium])
        .onAppear {
            selectedVendor = currentVendor
            selectedCollectionId = currentCollectionId
        }
    }
}
