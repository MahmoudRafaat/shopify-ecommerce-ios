//
//  SettingsRowStyle.swift
//  shopify-ecommerce-ios
//
//  Created by Mahmoud Raafat Mustafa on 04/07/2026.
//

import SwiftUI
enum SettingsRowStyle {
    case navigation
    case toggle(Binding<Bool>)
    case destructive
    
    var iconColor: Color {
        switch self {
        case .destructive:
            return AppColor.dangerDefault
        default:
            return Color(.darkGray)
        }
    }
    
    var titleColor: Color {
        switch self {
        case .destructive:
            return AppColor.dangerDefault
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
