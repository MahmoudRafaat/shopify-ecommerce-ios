//
//  OrdersListView.swift
//  shopify-ecommerce-ios
//
//  Created by Mahmoud Raafat Mustafa on 06/07/2026.
//


import SwiftUI

struct OrdersListView: View {
    @State private var viewModel: OrdersListViewModel
    @State private var selectedOrder: OrderDisplayModel?
    @Environment(\.dismiss) private var dismiss

    init(viewModel: OrdersListViewModel = OrdersListViewModel()) {
        self._viewModel = State(initialValue: viewModel)
    }
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                if viewModel.uiState.isLoading && viewModel.uiState.orders.isEmpty {
                    ForEach(0..<5, id: \.self) { _ in
                        OrderSkeletonRow()
                    }
                } else if viewModel.uiState.isEmpty {
                    EmptyOrdersView()
                        .padding(.top, 60)
                } else {
                    ForEach(viewModel.uiState.orders) { order in
                        OrderRowView(order: order)
                            .onTapGesture {
                                selectedOrder = order
                            }
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 16)
        }
        .background(AppColor.backgroundPrimary)
        .navigationTitle("Orders")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    dismiss()
                } label: {
                    HStack(spacing: 4) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 16, weight: .medium))
                        Text("Settings")
                            .font(.system(size: 16, weight: .medium))
                    }
                    .foregroundStyle(.appPrimary)
                }
            }
        }
        .refreshable {
            await viewModel.loadOrders()
        }
        .showCustomAlert(title: "Error", errorMessage: $viewModel.uiState.errorMessage)
        .showLoading(if: viewModel.uiState.isLoading && viewModel.uiState.orders.isEmpty)
        .onAppear {
            if viewModel.uiState.orders.isEmpty && viewModel.uiState.errorMessage == nil {
                Task { await viewModel.loadOrders() }
            }
        }
        .navigationDestination(item: $selectedOrder) { order in
            OrderDetailsView(order: order)
        }
    }
}

struct EmptyOrdersView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "shippingbox")
                .font(.system(size: 56))
                .foregroundStyle(AppColor.textSecondary.opacity(0.5))
            
            Text("No Orders Yet")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundStyle(.primary)
            
            Text("Your purchases will show up here once you start shopping")
                .font(.subheadline)
                .foregroundStyle(AppColor.textSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 40)
    }
}

