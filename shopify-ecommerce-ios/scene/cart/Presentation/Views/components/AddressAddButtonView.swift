//
//  AddButtonView.swift
//  shopify-ecommerce-ios
//
//  Created by albaraa alsayed on 18/01/1448 AH.
//

import SwiftUI

struct AddressAddButtonView: View {
    let action : () -> Void
    var body: some View {
        Button(action: action) {
            ZStack {
                Image(systemName: "plus.circle")
                    .font(.system(size: 24))
            }
            .frame(width: 80, height: 80)
            .background(AppColor.backgroundPrimary)
            .cornerRadius(8)
            .shadow(color: Color.black.opacity(0.1), radius: 20, x: 0, y: 0)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    AddressAddButtonView(action: {})
}
