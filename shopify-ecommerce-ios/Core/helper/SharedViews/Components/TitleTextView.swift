//
//  TitleTextView.swift
//  shopify-ecommerce-ios
//
//  Created by albaraa alsayed on 17/01/1448 AH.
//

import SwiftUI

struct TitleTextView: View {
    var body: some View {
        HStack {
            
            Spacer()
            
            // ActionChipButton(title: "Sort", systemImage: "sort-icon") { ... }
            // ActionChipButton(title: "Filter", systemImage: "filter-icon") { ... }
        }
        .padding(.horizontal, 16)
    }
}

#Preview {
    TitleTextView()
}
