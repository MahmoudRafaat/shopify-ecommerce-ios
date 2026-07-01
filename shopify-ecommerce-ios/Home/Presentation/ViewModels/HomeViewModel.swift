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
    private weak var coordinator: HomeCoordinator?
    
    private(set) var categories: [Category] = []
    private(set) var categorySections: [(title: String, products: [Product])] = []
    
    private var productTypePool : [String] = []
    
    init(
        getProductsUseCase: GetProductsUseCaseProtocol,
        getCategoriesUseCase: GetCategoriesUseCaseProtocol,
        coordinator: HomeCoordinator?
    ) {
        self.getProductsUseCase = getProductsUseCase
        self.getCategoriesUseCase = getCategoriesUseCase
        self.coordinator = coordinator
    }
    
    func fetchData() async {
        do {
            async let fetchedProducts = getProductsUseCase.execute()
            async let fetchedCategories = getCategoriesUseCase.execute()
            
            let allProducts = try await fetchedProducts
            productTypePool = Array(Set(allProducts.map(\.productType))).filter { !$0.isEmpty }
            
            print(productTypePool)
            let allCategories = try await fetchedCategories
            
            self.categories = allCategories
            
            let shuffledTypes = productTypePool.shuffled() 
            
            var sections: [(title: String, products: [Product])] = []
            
            for type in shuffledTypes {
                if sections.count == 2 { break }
                
                let matchedProducts = allProducts.filter { product in
                    product.productType.localizedCaseInsensitiveContains(type)
                }
                
                if !matchedProducts.isEmpty {
                    sections.append((title: type.capitalized, products: matchedProducts))
                }
            }
            
            self.categorySections = sections
            
        } catch {
            print("Error fetching products or categories: \(error)")
        }
    }
}
