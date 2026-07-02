//
//  HomeHeaderView.swift
//  shopify-ecommerce-ios
//
//  Created by Yomna on 27/06/2026.
//

import SwiftUI

struct HeaderView: View {
    @State var searchText = ""

    var autoFocus: Bool = false
    var onSearchTap: (() -> Void)? = nil
    
    @FocusState private var isTextFieldFocused: Bool
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Button {
                } label: {
                    Image("lines-icon").foregroundStyle(.black)
                }
                
                Spacer()
                
                HStack(spacing: 8) {
                    Image("logo")
                    Text("Stylish")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundStyle(Color(.appBlue))
                }
                
                Spacer()
                
                Button {
                    
                } label: {
                    Image("profile")
                        .resizable()
                        .frame(width: 40, height: 40)
                        .clipShape(Circle())
                }
            }
            .padding(.horizontal, 14)
            
            SearchField(searchText: $searchText)
                .focused($isTextFieldFocused)
                .padding(.horizontal, 16)
                .overlay {
                   if onSearchTap != nil {
                        Color.white.opacity(0.001)
                            .onTapGesture {
                                onSearchTap?()
                            }
                    }
                }
        }
        .onAppear {
            if autoFocus {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    isTextFieldFocused = true
                }
            }
        }
    }
}

#Preview {
    HeaderView(searchText: "", autoFocus: false)
}
