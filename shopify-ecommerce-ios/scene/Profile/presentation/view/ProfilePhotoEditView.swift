//
//  ProfilePhotoEditView.swift
//  shopify-ecommerce-ios
//
//  Created by Mahmoud Raafat Mustafa on 02/07/2026.
//


import SwiftUI

struct ProfilePhotoEditView: View {
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            Circle()
                .fill(Color.pink.opacity(0.8))
                .frame(width: 90, height: 90)
                .overlay {
                    Image(systemName: "person.fill")
                        .resizable()
                        .scaledToFit()
                        .padding(20)
                        .foregroundStyle(.white)
                        .clipShape(Circle())
                }
            
            Button {
                // Action to change photo
            } label: {
                Image(systemName: "pencil")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundStyle(.white)
                    .frame(width: 28, height: 28)
                    .background(Color.blue)
                    .clipShape(Circle())
                    .overlay(
                        Circle().stroke(Color.white, lineWidth: 2)
                    )
            }
            .offset(x: 0, y: 0)
        }
    }
}
