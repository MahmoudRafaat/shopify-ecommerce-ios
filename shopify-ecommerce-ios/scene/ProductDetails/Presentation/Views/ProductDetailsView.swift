//
//  ProductDetailsView.swift
//  shopify-ecommerce-ios
//
//  Created by Yomna on 03/07/2026.
//

import SwiftUI

struct ProductDetailsView: View {

    let state: ProductDetailsUIState
    let onSizeSelected: (String) -> Void
    @Environment(HomeCoordinator.self) var coordinator

    var body: some View {

        ScrollView {

            VStack(alignment: .leading, spacing: 24) {

                ProductImageSection(
                    state: state.imageSection
                )

                ProductSizeSection(
                    state: state.sizeSection,
                    onSizeSelected: onSizeSelected
                )

                ProductInfoSection(
                    state: state.infoSection
                )

                ProductActionButtons(
                    state: state.actionsSection,
                    onAddToCart: {},
                    onBuyNow: {}
                )

                DeliveryBanner(
                    state: state.deliverySection
                )

                similarProductsSection
            }
            .padding(.horizontal,16)
        }
    }
}

private extension ProductDetailsView {

    var similarProductsSection: some View {

        VStack(alignment: .leading, spacing: 16) {

            Text("You Might Also Like")
                .font(.title3)
                .fontWeight(.bold)
                .padding(.horizontal, 16)

            ProductsScrollView(
                products: state.similarProducts,
                onProductTap: { productID in
                    coordinator.goToProductDetail(id: productID)
                    
                }
            )
        }
    }
}

#Preview {

    ProductDetailsView(
        state: ProductDetailsUIState(

            imageSection: ProductImageSectionState(
                images: [
                    "https://picsum.photos/400/400",
                    "https://picsum.photos/401/400",
                    "https://picsum.photos/402/400"
                ],selectedIndex: 0
            ),

            sizeSection: ProductSizeSectionState(
                selectedSize: "7 UK",
                availableSizes: [
                    "6 UK",
                    "7 UK",
                    "8 UK",
                    "9 UK"
                ]
            ),

            infoSection: ProductInfoSectionState(
                title: "Nike Air Max 270",
                subtitle: "Men's Shoes",

                rating: 4.8,
                reviewCount: 270,

                oldPrice: "$180",
                currentPrice: "$150",
                discountText: "20% OFF",

                description: """
                The Nike Air Max 270 delivers visible cushioning under every step. The design draws inspiration from Air Max icons while providing modern comfort for everyday wear.
                """,

                tags: [
                    ProductTag(
                        icon: "mappin.and.ellipse",
                        title: "Nearest Store"
                    ),
                    ProductTag(
                        icon: "lock.fill",
                        title: "VIP"
                    ),
                    ProductTag(
                        icon: "arrow.uturn.backward",
                        title: "Return Policy"
                    )
                ]
            ),

            deliverySection: DeliveryBannerState(
                title: "Delivery in",
                subtitle: "1 within Hour"
            ),

            actionsSection: ProductActionsState(
                cartTitle: "Add to Cart",
                buyTitle: "Buy Now"
            ),

            similarProducts: [
                Product(
                    id: 1,
                    image: "watch",
                    name: "2021 Pilot's Watch",
                    description: "IWC Schaffhausen Pilot Watch",
                    price: 1500,
                    isAvailabe: true,
                    productType: "Watch"
                ),
                Product(
                    id: 2,
                    image: "watch",
                    name: "Classic Watch",
                    description: "Luxury collection",
                    price: 2200,
                    isAvailabe: true,
                    productType: "Watch"
                )
            ]
        ), onSizeSelected: {_ in}
    )
}
