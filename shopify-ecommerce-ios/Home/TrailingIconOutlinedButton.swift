//
//  TrailingIconOutlinedButton.swift
//  shopify-ecommerce-ios
//
//  Created by albaraa alsayed on 13/01/1448 AH.
//

import SwiftUI

struct TrailingIconOutlinedButton: View {
    let action: () -> Void
    let 
    var body: some View {
        Button(action: {
            action()
        }) {
            HStack {
                Text("Shop now")
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
    TrailingIconOutlinedButton(action: {})
}
