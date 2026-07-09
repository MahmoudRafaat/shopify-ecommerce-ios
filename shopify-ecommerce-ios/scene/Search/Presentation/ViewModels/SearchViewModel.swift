//
//  SearchViewModel.swift
//  shopify-ecommerce-ios
//
//  Created by albaraa alsayed on 20/01/1448 AH.
//

import Foundation
import Observation

@Observable
class SearchViewModel {
    
    private let searchProductsUseCase: SearchProductsUseCaseProtocol
    
    var uiState = SearchUIState()
    
    var searchText: String = "" {
        didSet { debounceSearch() }
    }
    
    var selectedSortOrder: SortOrder? = nil
    
    var selectedVendor: String = "" {
        didSet { debounceSearch() }
    }
    
    var selectedCollectionId: Int? = nil {
        didSet { debounceSearch() }
    }
    
    var availableVendors: [SearchVendor] = []
    var availableCategories: [SearchCategory] = []
    
    private var allProducts: [SearchProduct] = []
    
    private var nextPageURL: URL? = nil
    
    private var isLoadingMore = false
    
    private var totalProductCount: Int = 0
    
    var canLoadMore: Bool {
        return nextPageURL != nil
    }
    
    var currentProducts: [SearchProduct] {
        return allProducts
    }
    
    var productCount: Int {
        return totalProductCount
    }
    
    var hasActiveFilters: Bool {
        return !selectedVendor.isEmpty || selectedCollectionId != nil
    }
    
    private var searchTask: Task<Void, Never>?
    
    init(searchProductsUseCase: SearchProductsUseCaseProtocol) {
        self.searchProductsUseCase = searchProductsUseCase
        
        Task {
            await fetchFilterOptions()
        }
    }
    
    func fetchFilterOptions() async {
        do {
            let (vendors, categories) = try await searchProductsUseCase.fetchFilterOptions()
            self.availableVendors = vendors
            self.availableCategories = categories
        } catch {
            print("Failed to fetch filter options: \(error)")
        }
    }
    
    private func debounceSearch() {
        searchTask?.cancel()
        searchTask = Task {
            try? await Task.sleep(nanoseconds: 500_000_000)
            guard !Task.isCancelled else { return }
            await fetchProducts()
        }
    }
    
    func performSearch() {
        searchTask?.cancel()
        searchTask = Task {
            await fetchProducts()
        }
    }
    
    func clearFilters() {
        selectedVendor = ""
        selectedCollectionId = nil
    }
    
    func clearSort() {
        selectedSortOrder = nil
        performSearch()
    }
    
    func toggleSortOrder() {
        if selectedSortOrder == .newest {
            selectedSortOrder = .oldest
        } else {
            selectedSortOrder = .newest
        }
        performSearch()
    }
    
    private func fetchProducts() async {
        allProducts = []
        nextPageURL = nil
        isLoadingMore = false
        uiState.isIdle = false
        uiState.isLoading = true
        uiState.error = nil
        
        let query = ProductQuery(
            title: searchText.isEmpty ? nil : searchText,
            vendor: selectedVendor.isEmpty ? nil : selectedVendor,
            collectionId: selectedCollectionId,
            order: selectedSortOrder
        )
        
        do {
            async let productsTask = searchProductsUseCase.execute(query: query)
            async let countTask = searchProductsUseCase.fetchProductsCount(query: query)
            
            let (result, count) = try await (productsTask, countTask)
            
            allProducts = result.products
            nextPageURL = result.nextPageURL
            totalProductCount = count
            uiState.isLoading = false
        } catch {
            if !Task.isCancelled {
                uiState.isLoading = false
                uiState.error = AppError.determine()
            }
        }
    }
    
    func loadMoreIfNeeded() {
        guard let url = nextPageURL, !isLoadingMore else { return }
        
        isLoadingMore = true
        uiState.isLoadingMore = true
        
        Task {
            do {
                let result = try await searchProductsUseCase.executeNextPage(url: url)
                allProducts.append(contentsOf: result.products)
                nextPageURL = result.nextPageURL
                uiState.isLoadingMore = false
            } catch {
                if !Task.isCancelled {
                    uiState.isLoadingMore = false
                    uiState.error = AppError.determine()
                }
            }
            isLoadingMore = false
        }
    }
}
