//
//  AppError.swift
//  shopify-ecommerce-ios
//

import Foundation

enum AppError: Equatable {
    case noInternet
    case dataProblem
    case custom(title: String, message: String, icon: String = "exclamationmark.triangle.fill")
    
    static func determine() -> AppError {
        return NetworkMonitor.shared.isConnected ? .dataProblem : .noInternet
    }
    
    var title: String {
        switch self {
        case .noInternet: return "No Internet Connection"
        case .dataProblem: return "Oops.. Something went wrong."
        case .custom(let title, _, _): return title
        }
    }
    
    var message: String {
        switch self {
        case .noInternet: return "Please check your internet connection and try again."
        case .dataProblem: return "There was a problem loading the data. Please try again later."
        case .custom(_, let message, _): return message
        }
    }
    
    var icon: String {
        switch self {
        case .noInternet: return "wifi.slash"
        case .dataProblem: return "exclamationmark.triangle.fill"
        case .custom(_, _, let icon): return icon
        }
    }
}
