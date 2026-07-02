//
//  SettingsRowStyle.swift
//  shopify-ecommerce-ios
//
//  Created by Mahmoud Raafat Mustafa on 02/07/2026.
//

import SwiftUI

enum SettingsRowStyle {
    case navigation
    case toggle(Binding<Bool>)
    case destructive
        
    var iconColor: Color {
        switch self {
        case .destructive:
            return .red
        default:
            return Color(.darkGray)
        }
    }
    
    var titleColor: Color {
        switch self {
        case .destructive:
            return .red
        default:
            return .primary
        }
    }
    
    var titleWeight: Font.Weight {
        switch self {
        case .destructive:
            return .semibold
        default:
            return .regular
        }
    }
}

struct SettingsRowView: View {
    let icon: String
    let title: String
    var style: SettingsRowStyle = .navigation
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundStyle(style.iconColor)
                .frame(width: 30)
            
            Text(title)
                .font(.system(size: 16, weight: style.titleWeight))
                .foregroundStyle(style.titleColor)
            
            Spacer()
            
            switch style {
            case .navigation:
                Image(systemName: "chevron.right")
                    .font(.footnote)
                    .foregroundStyle(Color(.systemGray3))
                
            case .toggle(let binding):
                Toggle("", isOn: binding)
                    .labelsHidden()
                    .tint(Color.pink) // Replace with our color
                
            case .destructive:
                EmptyView()
            }
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 20)
        .background(Color.white)
    }
}
