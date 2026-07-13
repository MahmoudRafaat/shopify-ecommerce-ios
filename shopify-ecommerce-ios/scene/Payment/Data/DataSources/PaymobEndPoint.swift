//
//  PaymobEndPoint.swift
//  shopify-ecommerce-ios
//

import Foundation
import Alamofire

/// Endpoints for Paymob's Acceptance API v1.
/// Uses a different base URL and authentication scheme from the Shopify endpoints.
enum PaymobEndPoint {
    case createIntention(body: Data, secretKey: String)

    // MARK: - Properties

    var baseURL: String { "https://accept.paymob.com/v1" }

    var path: String {
        switch self {
        case .createIntention: return "/intention"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .createIntention: return .post
        }
    }

    var headers: HTTPHeaders {
        switch self {
        case .createIntention(_, let secretKey):
            return [
                "Authorization": "Token \(secretKey)",
                "Content-Type": "application/json"
            ]
        }
    }

    var body: Data? {
        switch self {
        case .createIntention(let body, _): return body
        }
    }

    /// Fully-qualified URL string for this endpoint.
    var urlString: String { baseURL + path }
}
