//
//  ProductDTO.swift
//  shopify-ecommerce-ios
//
//  Created by albaraa alsayed on 14/01/1448 AH.
//

import Foundation
import Playgrounds
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


#Playground {

    if let adminToken = Bundle.main.infoDictionary?["ShopifyAdminToken"] as? String {
        print("My Token is: \(adminToken)")
    } else {
        print("Nooooo - Token not found")
    }
    let urlString = "https://\(SecretConstants.apiKey):\(SecretConstants.password)@\(SecretConstants.hostname)/admin/api/2026-01/products.json"
    
    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .convertFromSnakeCase

    AF.request(urlString)
        .validate()
        .responseDecodable(of: ProductsResponse.self, decoder: decoder) { response in
            
            switch response.result {
            case .success(let productsResponse):
                let productDTOs = productsResponse.products
                print("Success Decoded \(productDTOs.count) products.")
                
                if let firstProductDTO = productDTOs.first {
                    print("Product Type: \(firstProductDTO.productType)")
                }
                
            case .failure(let error):
                print("Network or Decoding Error: \(error)")
            }
        }
}
