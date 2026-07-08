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
    private(set) var products: [ProductCollection] = []
    
    var collcetionId: Int?
    
    var isLoading: Bool = true
    var isLoadingMore: Bool = false
    
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
        isLoading = true
        products = []
        nextPageURL = nil
        isLoadingMore = false
        
        do {
            guard let collcetionId else { return }
            let query = searchText.isEmpty ? nil : searchText
            let result = try await getCollectionProductsUseCase.execute(collectionId: collcetionId, searchQuery: query)
            products = result.products
            nextPageURL = result.nextPageURL
        } catch {
            print("Error fetching products: \(error)")
        }
        isLoading = false
    }
    
    func loadMoreIfNeeded() {
        guard let url = nextPageURL, !isLoadingMore else { return }
        
        isLoadingMore = true
        
        Task {
            do {
                let result = try await getCollectionProductsUseCase.fetchNextPage(url: url)
                products.append(contentsOf: result.products)
                nextPageURL = result.nextPageURL
            } catch {
                print("Error fetching next page: \(error)")
            }
            isLoadingMore = false
        }
    }
}
