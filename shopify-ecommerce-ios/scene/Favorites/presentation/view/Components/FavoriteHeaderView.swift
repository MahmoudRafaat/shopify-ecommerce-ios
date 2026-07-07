//
//  FavoriteHeaderView.swift
//  shopify-ecommerce-ios
//
//  Created by Ehab Salah on 07/07/2026.
//

import SwiftUI

struct FavoriteHeaderView: View {
    var body: some View {
        HStack {
            Spacer()
            Text("Favorites")
                .font(.title2)
                .fontWeight(.bold)
            Spacer()
        }
        .padding(.horizontal)
        .padding(.top)
    }
}

#Preview {
    FavoriteHeaderView()
}
