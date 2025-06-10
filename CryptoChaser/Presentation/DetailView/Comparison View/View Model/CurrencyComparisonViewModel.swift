//
//  CurrencyComparisonViewModel.swift
//  CryptoChaser
//
//  Created by Ernesto Sánchez Kuri on 10/06/25.
//

import Foundation

class CurrencyComparisonViewModel {
    let currentCurrency: Currency
    let title: String
    let currencies: [Currency]
    let selectedProperty: SortableProperties
    
    init(currentCurrency: Currency, title: String, coins: [Currency], selectedProperty: SortableProperties) {
        self.currentCurrency = currentCurrency
        self.title = title
        self.currencies = coins
        self.selectedProperty = selectedProperty
    }
    
    func lookForCoinWith(name: String) -> Currency? {
        return currencies.filter { $0.name == name }.first
    }
    
    func valueForProperty(currency: Currency) -> Double {
        switch selectedProperty {
        case .currentPrice:
            return currency.currentPrice
        case .priceChange24h:
            return currency.priceChange24h ?? 0
        case .totalVolume:
            return currency.totalVolume ?? 0
        case .marketCapRank:
            return Double(currency.marketCapRank ?? 0)
        case .high24:
            return currency.high24 ?? 0
        case .low24:
            return currency.low24 ?? 0
        case .marketCap:
            return currency.marketCap ?? 0
        }
    }
    
    func annotationValue(for currency: Currency) -> String {
        switch selectedProperty {
        case .currentPrice:
            return currency.currentPrice.formatCurrency()
        case .priceChange24h:
            return currency.priceChange24h?.formatCurrency() ?? ""
        case .totalVolume:
            return currency.totalVolume?.formatBigNumber() ?? ""
        case .marketCapRank:
            return "\(currency.marketCapRank ?? 0)"
        case .high24:
            return currency.high24?.formatCurrency() ?? ""
        case .low24:
            return currency.low24?.formatCurrency() ?? ""
        case .marketCap:
            return currency.marketCap?.formatCurrency() ?? ""
        }
    }
}
