//
//  TypingIndicatorView.swift
//  shopify-ecommerce-ios
//
//  Created by Mahmoud Raafat Mustafa on 07/07/2026.
//

import SwiftUI

struct TypingIndicatorView: View {
    @State private var animationOffset = 0.0
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 6) {
                    ForEach(0..<3) { index in
                        Circle()
                            .fill(Color.appBlue.opacity(0.6))
                            .frame(width: 8, height: 8)
                            .offset(y: animationOffset)
                            .animation(
                                .easeInOut(duration: 0.5)
                                .repeatForever()
                                .delay(Double(index) * 0.15),
                                value: animationOffset
                            )
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(Color.white)
                .clipShape(AsymmetricBubbleShape(isUser: false))
                .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
            }
            Spacer()
        }
        .padding(.vertical, 4)
        .onAppear {
            animationOffset = -4
        }
        .transition(.scale(scale: 0.8, anchor: .bottomLeading).combined(with: .opacity))
    }
}
