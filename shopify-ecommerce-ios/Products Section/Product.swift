//
//  Product.swift
//  shopify-ecommerce-ios
//
//  Created by albaraa alsayed on 13/01/1448 AH.
//

import Foundation
import Playgrounds

struct Product : Identifiable {
    let id: UUID = UUID()
    let image: String
    let name: String
    let description: String
    let price: Float
    let discount: Int
    
    var oldPrice: Float {
        return price / (1 - (Float(discount) / 100.0))
    }
    
    let stars: Float
    let reviewers: Int
}

struct ProductsResponse: Codable {
    let products: [ProductModel]
}

struct ProductModel: Codable, Identifiable {
    let id: Int
    let title: String
    let bodyHtml: String?
    let vendor: String
    let productType: String
    let tags: String
    let status: String
    
    let variants: [VariantModel]
    let options: [ProductOption]?
    let images: [ImageModel]
    let image: ImageModel?
}

struct ProductOption: Codable, Identifiable {
    let id: Int
    let name: String
    let values: [String]
}

struct VariantModel: Codable, Identifiable {
    let id: Int
    let price: String
    let title: String
}

struct ImageModel: Codable, Identifiable {
    let id: Int
    let src: String
}


#Playground {
    let apiKey = "aa8d104ab1b323002f6385dd093896ff"
    let apiPassword = "apiPassword"
    let hostname = "mad46-ios-team4.myshopify.com"

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
            let products = response.products
            
            print("Success Decoded \(products.count) products.")
            
            if let firstProduct = products.first {
                print("Product Type: \(firstProduct.productType)")
            }
            
        } catch {
            print("Decoding Error: \(error)")
        }
    }
        
    task.resume()
}
