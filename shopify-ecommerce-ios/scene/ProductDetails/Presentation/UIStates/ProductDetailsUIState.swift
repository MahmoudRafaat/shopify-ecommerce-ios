//
//  ProductDetailsUIState.swift
//  shopify-ecommerce-ios
//
//  Created by Yomna on 03/07/2026.
//

import Foundation

struct ProductDetailsUIState: Equatable {
    let imageSection: ProductImageSectionState
    let sizeSection: ProductSizeSectionState
    let infoSection: ProductInfoSectionState
    let deliverySection: DeliveryBannerState
    let actionsSection: ProductActionsState

//    let similarProducts: [Product]
}

extension ProductDetailsUIState {

    /// Returns a copy of this state with a new size selected.
    /// Keeps partial-update logic in one place instead of scattered
    /// across view models / call sites.
    func withSelectedSize(_ size: String) -> Self {
        ProductDetailsUIState(
            imageSection: imageSection,
            sizeSection: ProductSizeSectionState(
                selectedSize: size,
                availableSizes: sizeSection.availableSizes
            ),
            infoSection: infoSection,
            deliverySection: deliverySection,
            actionsSection: actionsSection
//            similarProducts: [Product]
        )
    }
}

struct ProductImageSectionState: Equatable {
    let images: [String]
    let selectedIndex: Int
}

struct ProductSizeSectionState: Equatable {
    let selectedSize: String
    let availableSizes: [String]
}

struct ProductInfoSectionState: Equatable {
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

struct ProductTag: Identifiable, Equatable {
    // Derived from content instead of UUID() so identity stays stable
    // across reloads/remaps — avoids spurious SwiftUI re-animation
    // in ForEach when the same tag is rebuilt from the domain layer.
    let id: String

    let icon: String
    let title: String

    init(icon: String, title: String) {
        self.icon = icon
        self.title = title
        self.id = "\(icon)-\(title)"
    }
}

struct ProductActionsState: Equatable {
    let cartTitle: String
    let buyTitle: String
}

struct DeliveryBannerState: Equatable {
    let title: String
    let subtitle: String
}

struct SimilarProductCardState: Identifiable, Equatable {

    let id: Int

    let image: String

    let title: String
    let subtitle: String

    let price: String

    let rating: Double
    let reviews: Int
}
