//
//  ProductCard.swift
//  shopify-ecommerce-ios
//
//  Created by albaraa alsayed on 13/01/1448 AH.
//

import SwiftUI

struct ProductCardView: View {
    let uiState: ProductUIState
    var onFavoriteToggle: (() -> Void)? = nil
    var onTap: () -> Void

    
    @State private var favoritesViewModel = FavoritesViewModel()
    @State private var isFavorite: Bool = false
    @AppStorage(AppConstants.isGuestMode) private var isGuestMode = false
    @State private var showLoginAlert = false

    @Environment(CurrencyService.self) private var currencyService
    
    var body: some View {
        VStack(spacing: 8) {
            
            Color.clear
                .frame(height: 124)
                .overlay(
                    CachedImageLoader(
                        urlString: uiState.image,
                        width: nil,
                        height: nil
                    )
                )
                .clipped()
                .cornerRadius(10)
            .overlay(alignment: .topTrailing) {
                Button(action: {
                    if isGuestMode {
                        showLoginAlert = true
                        return
                    }
                    if isFavorite {
                        favoritesViewModel.removeFavorite(id: uiState.id)
                    } else {
                        let favProduct = FavoriteProduct(
                            id: uiState.id,
                            image: uiState.image,
                            name: uiState.name,
                            productDescription: uiState.description,
                            price: uiState.price,
                            isAvailable: uiState.isAvailabe,
                            productType: uiState.productType,
                            vendor: uiState.vendor
                        )
                        favoritesViewModel.addFavorite(product: favProduct)
                    }
                    isFavorite.toggle()
                    onFavoriteToggle?()
                }) {
                    Image(systemName: isFavorite ? "heart.fill" : "heart")
                        .font(.system(size: 16))
                        .foregroundColor(isFavorite ? .appPrimary : AppColor.textSecondary)
                        .padding(8)
                        .background(Circle().fill(AppColor.backgroundPrimary.opacity(0.8)))
                }
                .padding(6)
            }
            
            
            VStack(alignment: .leading, spacing: 4) {
                Text(uiState.name)
                    .font(.system(size: 12, weight: .semibold))
                    .lineLimit(1)
                
                HStack(spacing: 4) {
                    Text(uiState.vendor)
                        .foregroundStyle(AppColor.backgroundPrimary)
                        .padding(.vertical, 2)
                        .padding(.horizontal, 6)
                        .background(.appBlue)
                        .cornerRadius(4)
                    Text("·")
                    Text(uiState.productType)
                        .foregroundStyle(AppColor.textSecondary)
                        .padding(.vertical, 2)
                        .padding(.horizontal, 6)
                        .background(AppColor.textSecondary.opacity(0.15))
                        .cornerRadius(4)
                }
                .font(.system(size: 10))
                .foregroundColor(.secondary)
                .lineLimit(1)
                
                Text(uiState.description)
                    .font(.system(size: 10))
                    .foregroundColor(AppColor.textSecondary)
                    .lineLimit(1)
                Spacer()
                Text(PriceFormatter.format(amount: uiState.price, currencyService: currencyService))
                    .font(.system(size: 12, weight: .bold))
                HStack(spacing: 4) {
                    Text(PriceFormatter.format(amount: uiState.oldPrice, currencyService: currencyService))
                        .font(.system(size: 10, weight: .regular))
                        .strikethrough()
                        .foregroundStyle(AppColor.textSecondary)
                    Text("\(uiState.discount)%Off")
                        .font(.system(size: 10, weight: .regular))
                        .foregroundStyle(Color.appLightRed)
                }
                
                HStack{
                    StarsView(rating: uiState.stars, starsSize: 10)
                    Text("(\(uiState.reviewers))")
                        .font(.system(size: 10, weight: .light))
                        .foregroundColor(AppColor.textSecondary)
                        .padding(.leading, 2)
                }
            }
            .padding(.horizontal, 8)
            .padding(.top, 2)
            .padding(.bottom, 16)
            
        }
        .frame(maxWidth: .infinity)
        .frame(height: 250)
        .background(AppColor.backgroundPrimary)
        .cornerRadius(10)
        .shadow(color: .gray.opacity(0.15), radius: 8, x: 0, y: 4)
        .onTapGesture {
            onTap()
        }
        .onAppear {
            isFavorite = favoritesViewModel.checkIsFavorite(id: uiState.id)
        }
        .alert("Login Required", isPresented: $showLoginAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Login Now") {
                isGuestMode = false
            }
        } message: {
            Text("Please login to access this feature.")
        }
    }
    
}

#Preview {
    ProductCardView(uiState: ProductUIState(product: Product(id: 1,
                                     image: "watch",
                                     name: "Women Printed Kurta",
                                     description: "Neque porro quisquam est qui dolorem ipsum quia",
                                     vendor: "NIKE",
                                     price: 1500.0,
                                     isAvailabe: true,
                                     productType: "accessories")),
                    onTap: {})
}
