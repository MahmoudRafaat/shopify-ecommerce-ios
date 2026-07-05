//
//  CollectionFactory.swift
//  shopify-ecommerce-ios
//
//  Created by albaraa alsayed on 20/01/1448 AH.
//

import Foundation

@MainActor
class CollectionFactory {
    static func makeCollectionViewModel() -> CollectionViewModel {
        let collectionService = CollectionService()
        let collectionRepo = CollectionRepoImpl(service: collectionService)
        let useCase = GetCollectionProductsUseCaseImp(repository: collectionRepo)
        return CollectionViewModel(getCollectionProductsUseCase: useCase)
    }
}
