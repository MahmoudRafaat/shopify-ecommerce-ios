//
//  SizeChip.swift
//  shopify-ecommerce-ios
//
//  Created by Yomna on 03/07/2026.
//

import SwiftUI

struct SizeChip: View {

    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {

        Button(action: action) {

            Text(title)
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundStyle(
                    isSelected
                    ? Color.white
                    : Color("appPink")
                )
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
                .background {

                    RoundedRectangle(cornerRadius: 12)
                        .fill(
                            isSelected
                            ? Color("appPink")
                            : Color.white
                        )
                }
                .overlay {

                    RoundedRectangle(cornerRadius: 12)
                        .stroke(
                            isSelected
                            ? Color.clear
                            : Color.gray.opacity(0.3),
                            lineWidth: 1
                        )
                }
        }
    }
}
//#Preview {
//    SizeChip()
//}
