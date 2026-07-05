//
//  CategoryDTO.swift
//  shopify-ecommerce-ios
//
//  Created by Yomna on 30/06/2026.
//


struct CategoryDTO: Codable {
    let id: Int
    let title: String
    let image: CategoryImageDTO?
    
    enum CodingKeys: String, CodingKey {
        case id, title, image
    }
}

struct CategoryImageDTO: Codable {
    let src: String
    
    enum CodingKeys: String, CodingKey {
        case src
    }
}
