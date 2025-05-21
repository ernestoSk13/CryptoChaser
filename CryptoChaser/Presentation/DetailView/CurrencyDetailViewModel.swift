//
//  CurrencyDetailViewModel.swift
//  CryptoChaser
//
//  Created by Ernesto Sánchez Kuri on 21/05/25.
//

import Foundation

final class CurrencyDetailViewModel {
    let currency: Currency
    var name: String { currency.name }
    var symbol: String { currency.symbol }
    var formattedPrice: String { currency.currentPrice.formatCurrency() }
    var imageUrl: URL { currency.image }
    var totalVolume: String { currency.totalVolume?.shortName() ?? "" }
    var highestPrice: String { currency.high24?.formatCurrency() ?? "N/A" }
    var lowestPrice: String { currency.low24?.formatCurrency() ?? "N/A" }
    var priceChange: String { currency.priceChange24h?.formatCurrency() ?? "-" }
    var marketCap: String { currency.marketCap?.formatCurrency() ?? "-" }
  
    init(currency: Currency) {
        self.currency = currency
    }
}
