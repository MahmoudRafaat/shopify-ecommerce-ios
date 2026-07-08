//
//  OrderStatus.swift
//  shopify-ecommerce-ios
//
//  Created by Mahmoud Raafat Mustafa on 06/07/2026.
//
import SwiftUI
enum OrderStatus: Hashable {
    case pending
    case processing
    case fulfilled
    case partial
    case cancelled
    case unknown
    
    var label: String {
        switch self {
        case .pending: return "Pending"
        case .processing: return "Processing"
        case .fulfilled: return "Fulfilled"
        case .partial: return "Partial"
        case .cancelled: return "Cancelled"
        case .unknown: return "Unknown"
        }
    }
    
    var color: Color {
        switch self {
        case .pending: return AppColor.warningDefault
        case .processing: return AppColor.brandPrimary
        case .fulfilled: return AppColor.successDefault
        case .partial: return Color.purple
        case .cancelled: return AppColor.textSecondary
        case .unknown: return AppColor.textSecondary
        }
    }
}

