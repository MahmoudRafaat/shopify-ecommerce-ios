//
//  SearchView.swift
//  shopify-ecommerce-ios
//
//  Created by albaraa alsayed on 16/01/1448 AH.
//

import SwiftUI

struct SearchView: View {
    @FocusState private var isSearchFieldFocused: Bool
    
    var body: some View {
        ScrollView {
            HeaderView(autoFocus: true)
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
