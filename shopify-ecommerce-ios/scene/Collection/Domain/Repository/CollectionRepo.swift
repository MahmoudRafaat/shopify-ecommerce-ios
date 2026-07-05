//
//  CollectionRepo.swift
//  shopify-ecommerce-ios
//
//  Created by albaraa alsayed on 20/01/1448 AH.
//

import Foundation

protocol CollectionRepo {
    func getCollectionProducts(collectionId: Int) async throws -> [Product]
}
