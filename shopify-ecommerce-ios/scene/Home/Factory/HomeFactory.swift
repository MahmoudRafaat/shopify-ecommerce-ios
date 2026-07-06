//
//  HomeFactory.swift
//  shopify-ecommerce-ios
//
//  Created by albaraa alsayed on 19/01/1448 AH.
//

import Foundation

@MainActor
final class HomeFactory {
    static func makeHomeViewModel() -> HomeViewModel {
        let remoteService = HomeRemoteDataSource()
        let repository = HomeRepoImpl(service: remoteService)
        let getProductsUseCase = GetProductsUseCase(repository: repository)
        let getCategoriesUseCase = GetCategoriesUseCase(repository: repository)
        
        return HomeViewModel(
            getProductsUseCase: getProductsUseCase,
            getCategoriesUseCase: getCategoriesUseCase
        )
    }
}
