//
//  CollectionOfAds.swift
//  shopify-ecommerce-ios
//
//  Created by albaraa alsayed on 12/01/1448 AH.
//

import SwiftUI

struct CollectionOfAds: View {
    
    @State private var currentIndex = 0
    var action: () -> Void = {}
    
    private var allAdCards: [AdCard] {
        [
            AdCard(title: "50-40% OFF", category: "shoes", colors: "All colours", action: action),
            AdCard(title: "30% OFF", category: "shirts", colors: "Red & Blue", action: action),
            AdCard(title: "20% OFF", category: "pants", colors: "Black", action: action)
        ]
    }
    
    var body: some View {
        VStack(spacing: 12) {
            TabView(selection: $currentIndex) {
                ForEach(0..<allAdCards.count, id: \.self) { index in
                    allAdCards[index]
                        .scaleEffect(currentIndex == index ? 1.0 : 0.85)
                        .opacity(currentIndex == index ? 1.0 : 0.7)
                        .animation(.easeInOut(duration: 0.35), value: currentIndex)
                        .tag(index)
                    
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .frame(height: 190)
            
            indexCircle(currentIndex)
        }
    }
    
    private func indexCircle(_ idx : Int) -> some View {
        return HStack {
            ForEach(0..<allAdCards.count, id: \.self){ index in
                Circle()
                    .fill(idx == index ? .appPink : .primary)
                    .opacity(idx == index ? 1 : 0.3)
                    .frame(height: index == idx ? 9 : 8)
                    .animation(.spring(), value: idx)
            }
        }
        .frame(height: 12)
    }
}

#Preview {
    CollectionOfAds()
}
