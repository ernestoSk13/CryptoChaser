//
//  CurrencyCellViewModel.swift
//  CryptoChaser
//
//  Created by Ernesto Sánchez Kuri on 20/05/25.
//

import Foundation

final class CurrencyCellViewModel {
    private let currency: Currency
    
    var name: String {
        "\(currency.id) \(currency.name)"
    }
    
    var price: String {
        currency.currentPrice.formatCurrency()
    }
    
    var lastUpdated: String {
        let lastUpdatedValue = currency.lastUpdatedDate?.shortForm ?? "N/A"
        return "Last updated: \(lastUpdatedValue)"
    }
    
    var imageURL: URL {
        currency.image
    }
    
    init(currency: Currency) {
        self.currency = currency
    }
}
