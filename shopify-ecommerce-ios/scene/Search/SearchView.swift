//
//  SearchView.swift
//  shopify-ecommerce-ios
//
//  Created by albaraa alsayed on 16/01/1448 AH.
//

import SwiftUI

struct SearchView: View {
    @FocusState private var isSearchFieldFocused: Bool
    let productsNumber: Int = 0
    var body: some View {
        ScrollView {
            HeaderView(autoFocus: true)
            HStack {
                Text("\(productsNumber) Products")
                    .font(.title2)
                    .fontWeight(.semibold)
                Spacer()
                
                ActionChipButton(title: "Sort", systemImage: "sort-icon") {  }
                ActionChipButton(title: "Filter", systemImage: "filter-icon") {  }
            }
            .padding(16)
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                isSearchFieldFocused = true
            }
        }
    }
}

#Preview {
    SearchView()
}
