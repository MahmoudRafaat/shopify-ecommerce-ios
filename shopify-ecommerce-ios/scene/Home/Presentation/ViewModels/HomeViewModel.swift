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
    
    private var hasFetchedData: Bool = false
    
    private(set) var categories: [Category] = []
    private(set) var categorySections: [(title: String, products: [Product])] = []
    
    var isCategoriesLoading: Bool = true
    var isProductsLoading: Bool = true
    
    var errorMessage: String? = nil
    
    init(
        getProductsUseCase: GetProductsUseCaseProtocol,
        getCategoriesUseCase: GetCategoriesUseCaseProtocol
    ) {
        self.getProductsUseCase = getProductsUseCase
        self.getCategoriesUseCase = getCategoriesUseCase
    }
    
    func fetchData() async {
        guard !hasFetchedData else { return }
        
        hasFetchedData = true
        errorMessage = nil
        
        async let categoriesTask: () = fetchCategories()
        async let productsTask: () = fetchProducts()
        
        _ = await (categoriesTask, productsTask)
    }
    
    private func fetchCategories() async {
        isCategoriesLoading = true
        do {
            self.categories = try await getCategoriesUseCase.execute()
        } catch {
            print("Error fetching categories: \(error)")
            self.errorMessage = error.localizedDescription
            self.hasFetchedData = false
        }
        isCategoriesLoading = false
    }
    
    private func fetchProducts() async {
        isProductsLoading = true
        do {
            let allProducts = try await getProductsUseCase.execute()
    
            let groupedProducts = Dictionary(grouping: allProducts) { product in
                product.productType.trimmingCharacters(in: .whitespacesAndNewlines).capitalized
            }
            
            let validGroups = groupedProducts.filter { !$0.key.isEmpty && !$0.value.isEmpty }
            
            let shuffledKeys = validGroups.keys.shuffled()
            let selectedKeys = Array(shuffledKeys.prefix(2))
            
            self.categorySections = selectedKeys.map { key in
                (title: key, products: validGroups[key]!)
            }
            
        } catch {
            print("Error fetching products: \(error)")
            self.errorMessage = error.localizedDescription
            self.hasFetchedData = false
        }
        isProductsLoading = false
    }
}
