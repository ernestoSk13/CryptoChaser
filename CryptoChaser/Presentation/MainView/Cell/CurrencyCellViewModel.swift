//
//  CurrencyCellViewModel.swift
//  CryptoChaser
//
//  Created by Ernesto Sánchez Kuri on 20/05/25.
//

import Foundation

final class CurrencyCellViewModel {
    private let currency: Currency
    
    var currencyIdentifier: String {
        currency.id
    }
    
    var cellTitle: String {
        "\(name) - (\(currencyIdentifier))"
    }
    
    var name: String {
        currency.name
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
