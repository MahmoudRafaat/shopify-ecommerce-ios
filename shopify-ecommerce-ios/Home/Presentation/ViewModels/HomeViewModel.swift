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
    
    private(set) var products: [Product] = []
    private(set) var categories: [Category] = []
    
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
            
            self.products = try await fetchedProducts
            self.categories = try await fetchedCategories
        } catch {
            print("Error fetching products or categories: \(error)")
        }
    }
}
