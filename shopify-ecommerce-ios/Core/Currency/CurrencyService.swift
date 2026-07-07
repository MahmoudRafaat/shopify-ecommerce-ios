//
//  CurrencyService.swift
//  shopify-ecommerce-ios
//
//  Created by albaraa alsayed on 22/01/1448 AH.
//

import Foundation
import SwiftUI
import Observation

@Observable
final class CurrencyService {
    static let shared = CurrencyService()
    
    var selectedCurrency: String {
        didSet {
            UserDefaults.standard.set(selectedCurrency, forKey: AppConstants.selectedCurrency)
        }
    }
    
    private let getExchangeRatesUseCase: GetExchangeRatesUseCase
    private var cachedRates: ExchangeRates?
    private let baseCurrency = "USD"
    
    let supportedCurrencies: [String] = [
        "USD", "EUR", "GBP", "EGP", "SAR",
        "AED", "JPY", "CAD", "AUD", "INR",
        "CHF", "CNY", "KWD", "BHD", "QAR"
    ].sorted()
    
    init(getExchangeRatesUseCase: GetExchangeRatesUseCase = CurrencyFactory.makeGetExchangeRatesUseCase()) {
        self.getExchangeRatesUseCase = getExchangeRatesUseCase
        self.selectedCurrency = UserDefaults.standard.string(forKey: AppConstants.selectedCurrency) ?? "USD"
    }
    
    func refreshRatesIfNeeded() async {
        let currentTime = Int(Date().timeIntervalSince1970)
        
        // Check if cached rates are still valid
        if let rates = cachedRates, rates.timeNextUpdateUnix > currentTime {
            return
        }
        
        do {
            let rates = try await getExchangeRatesUseCase.execute(base: baseCurrency)
            self.cachedRates = rates
        } catch {
            print("Failed to fetch exchange rates: \(error.localizedDescription)")
            // On failure, keep using the old cache or default to no conversion
        }
    }
    
    func convert(amount: Double, from: String = "USD", to: String? = nil) -> Double {
        let targetCurrency = to ?? selectedCurrency
        
        guard let rates = cachedRates else {
            // Fallback: 1:1 if no rates are available
            return amount
        }
        
        if from == targetCurrency { return amount }
        
        let fromRate = rates.rates[from] ?? 1.0
        let toRate = rates.rates[targetCurrency] ?? 1.0
        
        return (amount / fromRate) * toRate
    }
    
    func formatPrice(_ amount: Double, currencyCode: String? = nil) -> String {
        let code = currencyCode ?? selectedCurrency
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = code
        // To use custom symbols if needed, or let system handle
        // formatter.currencySymbol = supportedCurrencies[code]
        
        return formatter.string(from: NSNumber(value: amount)) ?? "\(code) \(String(format: "%.2f", amount))"
    }
}
