//
//  SearchFactory.swift
//  shopify-ecommerce-ios
//
//  Created by albaraa alsayed on 20/01/1448 AH.
//

import Foundation

@MainActor
class SearchFactory {
    static func makeSearchViewModel() -> SearchViewModel {
        let dataSource = SearchRemoteDataSource()
        let repository = SearchProductRepoImpl(dataSource: dataSource)
        let useCase = SearchProductsUseCase(repository: repository)
        return SearchViewModel(searchProductsUseCase: useCase)
    }
}
