//
//  MessageBubbleView.swift
//  shopify-ecommerce-ios
//
//  Created by Mahmoud Raafat Mustafa on 07/07/2026.
//

import SwiftUI

struct MessageBubbleView: View {
    let message: Message
    
    var body: some View {
        HStack {
            if message.isUser {
                Spacer()
            }
            
            VStack(alignment: message.isUser ? .trailing : .leading, spacing: 4) {
                if !message.attachments.isEmpty {
                    ForEach(message.attachments) { attachment in
                        if attachment.type == .image, let image = UIImage(data: attachment.data) {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 220, height: 220)
                                .clipShape(RoundedRectangle(cornerRadius: 16))
                                .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
                        }
                    }
                }
                
                if !message.content.isEmpty {
                    Text(message.content)
                        .font(.body)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                        .background(
                            Group {
                                if message.isUser {
                                    LinearGradient(
                                        colors: [.appBlue, AppColor.brandPrimary],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                } else {
                                    AppColor.backgroundPrimary
                                }
                            }
                        )
                        .foregroundStyle(message.isUser ? AppColor.backgroundPrimary : .primary)
                        .clipShape(
                            AsymmetricBubbleShape(isUser: message.isUser)
                        )
                        .shadow(color: message.isUser ? .appBlue.opacity(0.3) : AppColor.textPrimary.opacity(0.05),
                                radius: 4, x: 0, y: 2)
                }
                
                Text(message.timestamp, style: .time)
                    .font(.caption2)
                    .foregroundStyle(AppColor.textSecondary)
                    .padding(message.isUser ? .trailing : .leading, 8)
            }
            
            if !message.isUser {
                Spacer()
            }
        }
        .padding(.vertical, 4)
        .transition(.scale(scale: 0.8, anchor: message.isUser ? .bottomTrailing : .bottomLeading).combined(with: .opacity))
    }
}

// Custom Shape for asymmetrical chat bubbles
struct AsymmetricBubbleShape: Shape {
    let isUser: Bool
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: [
                .topLeft,
                .topRight,
                isUser ? .bottomLeft : .bottomRight
            ],
            cornerRadii: CGSize(width: 18, height: 18)
        )
        return Path(path.cgPath)
    }
}
