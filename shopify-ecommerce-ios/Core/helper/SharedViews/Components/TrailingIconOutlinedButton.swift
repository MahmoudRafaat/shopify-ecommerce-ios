//
//  TrailingIconOutlinedButton.swift
//  shopify-ecommerce-ios
//
//  Created by albaraa alsayed on 13/01/1448 AH.
//

import SwiftUI

struct TrailingIconOutlinedButton: View {
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(action: {
            action()
        }) {
            HStack {
                Text(title)
                Image(systemName: "chevron.right")
            }
            .foregroundStyle(Color.white)
            .padding(10)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .strokeBorder(.white, lineWidth: 2)
            )
        }
    }
}

#Preview {
    TrailingIconOutlinedButton(title: "Shop now", action: {})
        .padding()
        .background(Color.red)
}
