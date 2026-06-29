//
//  SwiftUIView.swift
//  shopify-ecommerce-ios
//
//  Created by Yomna on 29/06/2026.
//

import SwiftUI

struct SearchField: View {
    @Binding var searchText : String
    var body: some View {
        HStack(spacing: 10){
            Image(systemName: "magnifyingglass")
                .font(.title3)
                .foregroundStyle(.gray)
            TextField("Search any Product...",text: $searchText)
                .font(.system(size: 18))
                .autocorrectionDisabled()
            if !searchText.isEmpty {
                Button {
                    searchText = ""
                } label: {
                    Image(systemName: "xmark.circle")
                        .foregroundStyle(.gray)
                }
            }
            
        } .padding(.horizontal, 20)
            .frame(height: 56)
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .shadow(
                color: .black.opacity(0.05),
                radius: 8,
                x: 0,
                y: 2
            )
    }
}

#Preview {
    @State var text = ""
    SearchField(
        searchText: $text
    )
}
