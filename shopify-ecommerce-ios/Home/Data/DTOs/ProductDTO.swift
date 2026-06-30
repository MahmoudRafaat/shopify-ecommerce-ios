//
//  ProductDTO.swift
//  shopify-ecommerce-ios
//
//  Created by albaraa alsayed on 14/01/1448 AH.
//

import Foundation
import Playgrounds

struct ProductDTO: Codable, Identifiable {
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

struct ProductOptionDTO: Codable, Identifiable {
    let id: Int
    let name: String
    let values: [String]
}

struct VariantDTO: Codable, Identifiable {
    let id: Int
    let price: String
    let title: String
}

struct ImageDTO: Codable, Identifiable {
    let id: Int
    let src: String
}


#Playground {
    let apiKey = "api key"
    let apiPassword = "api password"
    let hostname = "host name"

    let urlString = "https://\(apiKey):\(apiPassword)@\(hostname)/admin/api/2026-01/products.json"
    guard let url = URL(string: urlString) else { return }
        
    let task = URLSession.shared.dataTask(with: url) { (data, _, error) in
        guard let data = data, error == nil else {
            print("Network error")
            return
        }
            
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            
            let response = try decoder.decode(ProductsResponse.self, from: data)
            let productDTOs = response.products

            print("Success Decoded \(productDTOs.count) products.")

            if let firstProductDTO = productDTOs.first {
                print("Product Type: \(firstProductDTO.productType)")
            }
            
        } catch {
            print("Decoding Error: \(error)")
        }
    }
        
    task.resume()
}
