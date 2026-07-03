//
//  ProductDTO.swift
//  shopify-ecommerce-ios
//
//  Created by albaraa alsayed on 14/01/1448 AH.
//

import Foundation
import Alamofire

struct ProductDTO: Codable {
    let id: Int
    let title: String
    let bodyHtml: String?
    let vendor: String
    let productType: String
    let tags: String
    let status: String
    
    let variants: [VariantDTO]
    let options: [ProductOptionDTO]?
    let images: [ImageDTO]
    let image: ImageDTO?
}

struct ProductOptionDTO: Codable {
    let id: Int
    let name: String
    let values: [String]
}

struct VariantDTO: Codable {
    let id: Int
    let price: String
    let title: String
    let inventoryQuantity: Int
}

struct ImageDTO: Codable {
    let id: Int
    let src: String
}
