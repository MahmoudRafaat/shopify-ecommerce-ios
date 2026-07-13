//
//  ProductDetailsUIStateMapper.swift
//  shopify-ecommerce-ios
//
//  Created by Yomna on 04/07/2026.
//

import Foundation

extension ProductDetails {

    func toUIState() -> ProductDetailsUIState {

        let variantMap = Dictionary(
            uniqueKeysWithValues: variants.map { ($0.title, $0.id) }
        )

        return ProductDetailsUIState(

            imageSection: ProductImageSectionState(
                images: images.map(\.src),
                selectedIndex: 0
            ),

            sizeSection: ProductSizeSectionState(
                selectedSize: variants.first?.title ?? "",
                availableSizes: variants.map(\.title),
                variantMap: variantMap
            ),

            infoSection: ProductInfoSectionState(
                title: title,
                subtitle: vendor,

                rating: 4.8,
                reviewCount: 120,

                oldPrice: "150",
                currentPrice: variants.first?.price ?? "",
                discountText: "20% OFF",

                description: description,

                tags: [
                    ProductTag(
                        icon: "shippingbox",
                        title: productType
                    )
                ]
            ),

            deliverySection: DeliveryBannerState(
                title: "Free Delivery",
                subtitle: "Delivered in 2-3 business days"
            ),

            actionsSection: ProductActionsState(
                cartTitle: "Add to Cart",
                buyTitle: "Buy Now"
            ),

            selectedVariantId: variants.first?.id,
            firstImageUrl: images.first?.src

//            similarProducts: []
        )
    }
}
