//
//  AIFloatingActionButton.swift
//  shopify-ecommerce-ios
//
//  Created by albaraa alsayed on 23/01/1448 AH.
//

import SwiftUI


struct AIFloatingActionButton: View {
    let action: () -> Void
    @State private var isAnimating = false

    var body: some View {
        Button(action: action) {
            ZStack {
                // Pulse effect
                Circle()
                    .fill(Color.appBlue.opacity(0.4))
                    .frame(width: 56, height: 56)
                    .scaleEffect(isAnimating ? 1.3 : 1.0)
                    .opacity(isAnimating ? 0.0 : 0.8)
                
                // Main Button
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [.appBlue, .blue],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 56, height: 56)
                    .shadow(color: .appBlue.opacity(0.4), radius: 8, x: 0, y: 4)
                
                Image(systemName: "sparkles")
                    .font(.system(size: 24, weight: .semibold))
                    .foregroundStyle(.white)
                    // Smooth, continuous rotation breathing effect
                    .rotationEffect(.degrees(isAnimating ? 15 : -5))
                    .scaleEffect(isAnimating ? 1.1 : 0.95)
            }
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 1.8).repeatForever(autoreverses: true)) {
                isAnimating = true
            }
        }
    }
}
