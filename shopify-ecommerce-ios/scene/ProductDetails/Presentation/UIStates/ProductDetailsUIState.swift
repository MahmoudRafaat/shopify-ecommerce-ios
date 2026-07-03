//
//  ProductDetailsUIState.swift
//  shopify-ecommerce-ios
//
//  Created by Yomna on 03/07/2026.
//

// ProductDetailsUIState.swift

import Foundation

struct ProductDetailsUIState {
    let imageSection: ProductImageSectionState
    let sizeSection: ProductSizeSectionState
    let infoSection: ProductInfoSectionState
    let deliverySection: DeliveryBannerState
    let actionsSection: ProductActionsState

    let similarProducts: [Product]
}
struct ProductImageSectionState {
    let images: [String]
    let selectedIndex: Int
}

struct ProductSizeSectionState {
    let selectedSize: String
    let availableSizes: [String]
}

struct ProductInfoSectionState {
    let title: String
    let subtitle: String

    let rating: Double
    let reviewCount: Int

    let oldPrice: String
    let currentPrice: String
    let discountText: String

    let description: String

    let tags: [ProductTag]
}

struct ProductTag: Identifiable {
    let id = UUID()

    let icon: String
    let title: String
}

struct ProductActionsState {
    let cartTitle: String
    let buyTitle: String
}

struct DeliveryBannerState {
    let title: String
    let subtitle: String
}

struct SimilarProductCardState: Identifiable {

    let id: Int

    let image: String

    let title: String
    let subtitle: String

    let price: String

    let rating: Double
    let reviews: Int
}
