//
//  CachedImageLoader.swift
//  shopify-ecommerce-ios
//
//  Created by albaraa alsayed on 16/01/1448 AH.
//

import SwiftUI
import Kingfisher

import SwiftUI
import Kingfisher

struct CachedImageLoader: View {
    let urlString: String
    let width: CGFloat?
    let height: CGFloat?
    
    var body: some View {
        KFImage(URL(string: urlString))
            .placeholder {
                ZStack {
                    Color.gray.opacity(0.1)
                    ProgressView().tint(.appPink)
                }
            }
            .onFailureImage(UIImage(named: "imgPlaceholder"))
            .resizable()
            .scaledToFill()
            .frame(width: width, height: height)
            .clipped()
    }
}

#Preview {
    CachedImageLoader(urlString: "", width: 100, height: 100)
}
