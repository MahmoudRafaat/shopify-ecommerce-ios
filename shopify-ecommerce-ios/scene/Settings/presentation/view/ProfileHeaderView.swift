//
//  ProfileHeaderView.swift
//  shopify-ecommerce-ios
//
//  Created by Mahmoud Raafat Mustafa on 02/07/2026.
//


import SwiftUI

struct ProfileHeaderView: View {
    let name: String
    let email: String
    // let imageUrl: URL? // mabay use it later
    
    var body: some View {
        HStack(spacing: 16) {
            Circle()
                .fill(Color(white: 0.90))
                .frame(width: 70, height: 70)
                .overlay {
                    Image(systemName: "person.fill")
                        .font(.largeTitle)
                        .foregroundStyle(.gray)
                }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(name)
                    .font(.title3)
                    .fontWeight(.bold)
                
                Text(email)
                    .font(.subheadline)
                    .foregroundStyle(.gray)
            }
            
            Spacer()
            
            Button {
                // Navigate to edit profile
            } label: {
                Image(systemName: "pencil.circle.fill")
                    .font(.title)
                    .foregroundStyle(Color.pink)
            }
        }
        .padding(20)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: Color.black.opacity(0.03), radius: 10, x: 0, y: 5)
    }
}
