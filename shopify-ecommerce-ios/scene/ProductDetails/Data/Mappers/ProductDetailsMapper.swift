//
//  ProductDetailsMapper.swift
//  shopify-ecommerce-ios
//
//  Created by Yomna on 04/07/2026.
//

import Foundation

extension ProductDTO {

    func toDomain() -> ProductDetails {

        ProductDetails(
            id: id,
            title: title,
            description: bodyHtml ?? "",
            vendor: vendor,
            productType: productType,
            tags: tags
                .split(separator: ",")
                .map {
                    $0.trimmingCharacters(in: .whitespaces)
                },

            images: images.map {
                $0.toDomain()
            },

            variants: variants.map {
                $0.toDomain()
            }
        )
    }
}

extension VariantDTO {

    func toDomain() -> ProductDetailsVariant {

        ProductDetailsVariant(
            id: id,
            title: title,
            price: price
        )
    }
}
extension ImageDTO {

    func toDomain() -> ProductDetailsImage {

        ProductDetailsImage(
            id: id,
            src: src
        )
    }
}
