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
        
        async let categoriesTask: () = fetchCategories()
        async let brandsTask: () = fetchBrands()
        async let productsTask: () = fetchProducts()
        
        _ = await (categoriesTask, brandsTask, productsTask)
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
            let allProducts = try await getProductsUseCase.execute()
    
            let groupedProducts = Dictionary(grouping: allProducts) { product in
                product.productType.trimmingCharacters(in: .whitespacesAndNewlines).capitalized
            }
            
            let validGroups = groupedProducts.filter { !$0.key.isEmpty && !$0.value.isEmpty }
            
            let shuffledKeys = validGroups.keys.shuffled()
            let selectedKeys = Array(shuffledKeys.prefix(2))
            
            self.uiState.categorySections = selectedKeys.map { key in
                (title: key, products: validGroups[key]!)
            }
            
        } catch {
            print("Error fetching products: \(error)")
            self.uiState.error = AppError.determine()
            self.hasFetchedData = false
        }
        uiState.isProductsLoading = false
    }
}
