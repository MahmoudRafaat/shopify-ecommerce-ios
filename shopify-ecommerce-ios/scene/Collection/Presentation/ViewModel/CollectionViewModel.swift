//
//  CollectionViewModel.swift
//  shopify-ecommerce-ios
//
//  Created by albaraa alsayed on 20/01/1448 AH.
//

import Foundation



@Observable
class CollectionViewModel {
    let getCollectionProductsUseCase: GetCollectionProductsUseCase
    
    var uiState = CollectionUIState()
    
    var collcetionId: Int?
    
    var searchText: String = "" {
        didSet { debounceSearch() }
    }
    
    private var nextPageURL: URL? = nil
    
    var canLoadMore: Bool {
        return nextPageURL != nil
    }
    
    private var searchTask: Task<Void, Never>?
    
    init(getCollectionProductsUseCase: GetCollectionProductsUseCase) {
        self.getCollectionProductsUseCase = getCollectionProductsUseCase
    }
    
    private func debounceSearch() {
        searchTask?.cancel()
        searchTask = Task {
            try? await Task.sleep(nanoseconds: 500_000_000)
            guard !Task.isCancelled else { return }
            await fetchProducts()
        }
    }
    
    func fetchProducts() async {
        uiState.isLoading = true
        uiState.products = []
        nextPageURL = nil
        uiState.isLoadingMore = false
        uiState.error = nil
        
        do {
            guard let collcetionId else { return }
            let query = searchText.isEmpty ? nil : searchText
            let result = try await getCollectionProductsUseCase.execute(collectionId: collcetionId, searchQuery: query)
            uiState.products = result.products
            nextPageURL = result.nextPageURL
        } catch {
            print("Error fetching products: \(error)")
            uiState.error = AppError.determine()
        }
        uiState.isLoading = false
    }
    
    func loadMoreIfNeeded() {
        guard let url = nextPageURL, !uiState.isLoadingMore else { return }
        
        uiState.isLoadingMore = true
        
        Task {
            do {
                let result = try await getCollectionProductsUseCase.fetchNextPage(url: url)
                uiState.products.append(contentsOf: result.products)
                nextPageURL = result.nextPageURL
            } catch {
                print("Error fetching next page: \(error)")
                uiState.error = AppError.determine()
            }
            uiState.isLoadingMore = false
        }
    }
}
