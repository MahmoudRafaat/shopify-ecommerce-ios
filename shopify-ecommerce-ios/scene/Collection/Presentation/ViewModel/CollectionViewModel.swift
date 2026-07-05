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
    private(set) var products : [ProductCollection] = []
    
    var collcetionId : Int?
    
    var isLoading: Bool = true
    
    init(getCollectionProductsUseCase: GetCollectionProductsUseCase) {
        self.getCollectionProductsUseCase = getCollectionProductsUseCase
    }
    
    func fetchProducts() async {
        isLoading = true
        do {
            guard let collcetionId else { return }
            products = try await getCollectionProductsUseCase.execute(collectionId: collcetionId)
            
        } catch {
            print("Error fetching products: \(error)")
        }
        isLoading = false
    }
}
