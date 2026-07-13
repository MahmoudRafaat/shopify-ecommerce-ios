//
//  HomeViewModel.swift
//  shopify-ecommerce-ios
//
//  Created by albaraa alsayed on 14/01/1448 AH.
//

import Foundation
import Observation



@Observable
class HomeViewModel {
    
    private let getProductsUseCase: GetProductsUseCaseProtocol
    private let getCategoriesUseCase: GetCategoriesUseCaseProtocol
    private let getBrandsUseCase: GetBrandsUseCaseProtocol
    
    private var hasFetchedData: Bool = false
    
    var uiState = HomeUIState()
    
    init(
        getProductsUseCase: GetProductsUseCaseProtocol,
        getCategoriesUseCase: GetCategoriesUseCaseProtocol,
        getBrandsUseCase: GetBrandsUseCaseProtocol
    ) {
        self.getProductsUseCase = getProductsUseCase
        self.getCategoriesUseCase = getCategoriesUseCase
        self.getBrandsUseCase = getBrandsUseCase
    }
    
    func fetchData() async {
        guard !hasFetchedData else { return }
        
        hasFetchedData = true
        uiState.error = nil
        
        async let brandsTask: () = fetchBrands()
        
        await fetchCategories()
        await fetchProducts()
        
        _ = await brandsTask
    }
    
    func refreshData() async {
        hasFetchedData = false
        await fetchData()
    }
    
    private func fetchCategories() async {
        uiState.isCategoriesLoading = true
        do {
            self.uiState.categories = try await getCategoriesUseCase.execute()
        } catch {
            print("Error fetching categories: \(error)")
            self.uiState.error = AppError.determine()
            self.hasFetchedData = false
        }
        uiState.isCategoriesLoading = false
    }
    
    private func fetchBrands() async {
        uiState.isBrandsLoading = true
        do {
            self.uiState.brands = try await getBrandsUseCase.execute()
        } catch {
            print("Error fetching brands: \(error)")
            self.uiState.error = AppError.determine()
            self.hasFetchedData = false
        }
        uiState.isBrandsLoading = false
    }
    
    private func fetchProducts() async {
        uiState.isProductsLoading = true
        do {
            let targetTitles = ["Accessories", "Clothing", "Men", "Shoes", "Snowboard", "Women"]
            let validCategories = uiState.categories.filter { category in
                targetTitles.contains { $0.caseInsensitiveCompare(category.title) == .orderedSame }
            }
            
            var sections: [(title: String, products: [Product])] = []
            
            try await withThrowingTaskGroup(of: (String, [Product]).self) { group in
                for category in validCategories {
                    group.addTask {
                        let products = try await self.getProductsUseCase.execute(collectionId: category.id)
                        return (category.title, products)
                    }
                }
                
                for try await (title, products) in group {
                    if !products.isEmpty {
                        sections.append((title, products))
                    }
                }
            }
            
            self.uiState.categorySections = sections.sorted { $0.title < $1.title }
            
        } catch {
            print("Error fetching products: \(error)")
            self.uiState.error = AppError.determine()
            self.hasFetchedData = false
        }
        uiState.isProductsLoading = false
    }
}
