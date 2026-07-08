//
//  MoneyConverter.swift
//  shopify-ecommerce-ios
//

import Foundation

/// Domain-layer utility for converting between human-readable price strings
/// and the integer-cent representation required by payment gateways.
///
/// Lives in the domain layer because "what does 99.99 mean in payment terms"
/// is a business rule, not a presentation or infrastructure concern.
enum MoneyConverter {

    // MARK: - String → Cents

    /// Converts a price string to the smallest currency unit (cents/piastres).
    ///
    /// Examples:
    /// ```
    /// MoneyConverter.toCents(from: "99.99")  // → 9999
    /// MoneyConverter.toCents(from: "100")    // → 10000
    /// MoneyConverter.toCents(from: "")       // → 0
    /// ```
    ///
    /// Uses `Decimal` arithmetic to avoid floating-point rounding errors.
    static func toCents(from priceString: String) -> Int {
        let sanitised = priceString
            .trimmingCharacters(in: .whitespaces)
            .replacingOccurrences(of: "$", with: "")  // strip currency symbols if present
            .replacingOccurrences(of: "£", with: "")
            .replacingOccurrences(of: "€", with: "")
        guard !sanitised.isEmpty, let decimal = Decimal(string: sanitised) else { return 0 }
        let cents = decimal * 100
        return NSDecimalNumber(decimal: cents).intValue
    }

    // MARK: - Cents → String

    /// Converts an integer-cent value back to a display string with two decimal places.
    ///
    /// Example: `MoneyConverter.toString(cents: 9999)` → `"99.99"`
    static func toString(cents: Int) -> String {
        let decimal = Decimal(cents) / 100
        return NSDecimalNumber(decimal: decimal).stringValue
    }
}
