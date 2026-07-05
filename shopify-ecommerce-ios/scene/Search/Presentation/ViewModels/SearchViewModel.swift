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
    
    private(set) var viewState: SearchViewState = .idle
    
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
    
    var productCount: Int {
        if case .success(let products) = viewState {
            return products.count
        }
        return 0
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
        viewState = .loading
        
        let query = ProductQuery(
            title: searchText.isEmpty ? nil : searchText,
            vendor: selectedVendor.isEmpty ? nil : selectedVendor,
            collectionId: selectedCollectionId,
            order: selectedSortOrder
        )
        
        do {
            let products = try await searchProductsUseCase.execute(query: query)
            viewState = .success(products)
        } catch {
            if !Task.isCancelled {
                viewState = .error(error.localizedDescription)
            }
        }
    }
}
