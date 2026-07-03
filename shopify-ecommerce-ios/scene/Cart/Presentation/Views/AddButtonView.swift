//
//  AddButtonView.swift
//  shopify-ecommerce-ios
//
//  Created by albaraa alsayed on 18/01/1448 AH.
//

import SwiftUI

struct AddButtonView: View {
    let action : () -> Void
    var body: some View {
        ZStack {
            Image(systemName: "plus.circle")
                .font(.system(size: 24))
        }
        .frame(width: 80, height: 80)
        .background(Color.white)
        .cornerRadius(8)
        .shadow(color: Color.black.opacity(0.1), radius: 20, x: 0, y: 0)
    }
}

#Preview {
    AddButtonView(action: {})
}
