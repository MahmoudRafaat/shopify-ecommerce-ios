import SwiftUI

struct PriceFormatter {
    static func format(amount: Float, currencyService: CurrencyService) -> String {
        let converted = currencyService.convert(amount: Double(amount))
        return currencyService.formatPrice(converted)
    }
    
    static func format(amountString: String, currencyService: CurrencyService) -> String {
        let amount = Double(amountString) ?? 0.0
        let converted = currencyService.convert(amount: amount)
        return currencyService.formatPrice(converted)
    }
}
