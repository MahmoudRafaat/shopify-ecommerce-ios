//
//  SearchView.swift
//  shopify-ecommerce-ios
//
//  Created by albaraa alsayed on 20/01/1448 AH.
//

import SwiftUI

struct SearchView: View {
    @State private var viewModel: SearchViewModel = SearchFactory.makeSearchViewModel()
    
    @State private var showFilterSheet = false
    
    var body: some View {
        VStack(spacing: 0) {
            HeaderView(searchText: $viewModel.searchText, autoFocus: true)
                .background(Color(.systemBackground))
            chipBar
            contentView
        }
        .sheet(isPresented: $showFilterSheet) {
            FilterSheetView(
                currentVendor: viewModel.selectedVendor,
                currentCollectionId: viewModel.selectedCollectionId,
                availableVendors: viewModel.availableVendors,
                availableCategories: viewModel.availableCategories,
                onApply: { vendor, collectionId in
                    viewModel.selectedVendor = vendor
                    viewModel.selectedCollectionId = collectionId
                    viewModel.performSearch()
                    showFilterSheet = false
                },
                onClear: {
                    viewModel.clearFilters()
                    showFilterSheet = false
                },
                onDismiss: { showFilterSheet = false }
            )
        }
        Spacer()
    }
    
    private var chipBar: some View {
        HStack {
            Text("\(viewModel.productCount) Products")
                .font(.title2)
                .fontWeight(.semibold)
            
            Spacer()
            
            ActionChipButton(
                title: viewModel.selectedSortOrder == .newest ? "Newest" :
                       viewModel.selectedSortOrder == .oldest ? "Oldest" : "Sort",
                systemImage: "sort-icon"
            ) {
                viewModel.toggleSortOrder()
            }
            
            ActionChipButton(
                title: viewModel.hasActiveFilters ? "Filtered" : "Filter",
                systemImage: "filter-icon"
            ) {
                showFilterSheet = true
            }
        }
        .padding(16)
    }
    
    @ViewBuilder
    private var contentView: some View {
        if viewModel.uiState.isIdle {
            idleView
        } else if viewModel.uiState.isLoading {
            loadingView
        } else if let error = viewModel.uiState.error {
            CustomContentUnavailableView(error: error, onRetry: {
                viewModel.performSearch()
            })
        } else {
            let products = viewModel.currentProducts
            if products.isEmpty {
                emptyView
            } else {
                SearchProductGrid(
                    products: products,
                    canLoadMore: viewModel.canLoadMore,
                    onReachedBottom: { viewModel.loadMoreIfNeeded() }
                )
            }
        }
    }
    
    private var idleView: some View {
        VStack(spacing: 12) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 48))
                .foregroundColor(AppColor.textSecondary.opacity(0.5))
            
            Text("Search for products")
                .font(.headline)
                .foregroundColor(AppColor.textSecondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.top, 80)
    }
    
    private var loadingView: some View {
        VStack {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: .appBlue))
                .scaleEffect(1.3)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.top, 80)
    }
    
    private var emptyView: some View {
        VStack(spacing: 12) {
            Image(systemName: "tray")
                .font(.system(size: 48))
                .foregroundColor(AppColor.textSecondary.opacity(0.5))
            
            Text("No products found")
                .font(.headline)
                .foregroundColor(AppColor.textSecondary)
            
            Text("Try adjusting your search or filters.")
                .font(.subheadline)
                .foregroundColor(AppColor.textSecondary.opacity(0.8))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.top, 80)
    }
}

#Preview {
    SearchView()
}
