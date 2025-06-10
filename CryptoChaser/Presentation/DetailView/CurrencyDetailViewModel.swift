//
//  CurrencyDetailViewModel.swift
//  CryptoChaser
//
//  Created by Ernesto Sánchez Kuri on 21/05/25.
//

import Foundation

struct CurrencyPropertyValue: Identifiable {
    var id: String {
        return title.lowercased().replacingOccurrences(of: " ", with: "_")
    }
    let title: String
    let value: String
    let associatedSorting: SortableProperties
    var icon: String = "dollarsign"
}

final class CurrencyDetailViewModel: ObservableObject {
    let currency: Currency
    let repository: CryptoRepository
    var name: String { currency.name }
    var currentPriceValue: Double { currency.currentPrice }
    var currentPrice: String { currency.currentPrice.formatCurrency() }
    var symbol: String { currency.symbol }
    var formattedPrice: String { currency.currentPrice.formatCurrency() }
    var imageUrl: URL { currency.image }
    var ranking : String { "#\(currency.marketCapRank ?? 0)" }
    var totalVolume: String { currency.totalVolume?.shortName() ?? "" }
    var highestPrice: String { currency.high24?.formatCurrency() ?? "N/A" }
    var lowestPrice: String { currency.low24?.formatCurrency() ?? "N/A" }
    var priceChange: String { currency.priceChange24h?.formatCurrency() ?? "-" }
    var marketCap: String { "$\(currency.marketCap?.shortName() ?? "-")" }
    @Published var coins: [Currency] = []
    @Published var selectedProperty: Int = 0
    
    
    lazy var properties: [CurrencyPropertyValue] = {
       [
        CurrencyPropertyValue(title: "Current Price", value: currentPrice, associatedSorting: .currentPrice),
        CurrencyPropertyValue(title: "Ranking", value: ranking, associatedSorting: .marketCapRank, icon: "list.number"),
        CurrencyPropertyValue(title: "Total Volume", value: totalVolume, associatedSorting: .totalVolume, icon: "numbers"),
        CurrencyPropertyValue(title: "Highest Price", value: highestPrice, associatedSorting: .high24),
        CurrencyPropertyValue(title: "Lowest Price", value: lowestPrice, associatedSorting: .low24),
        CurrencyPropertyValue(title: "Price Change", value: priceChange, associatedSorting: .priceChange24h),
        CurrencyPropertyValue(title: "Market Cap", value: marketCap, associatedSorting: .marketCap)
       ]
    }()
    
    
    init(currency: Currency, repository: CryptoRepository) {
        self.currency = currency
        self.repository = repository
        fillCoinsArray()
    }
    
    func fillCoinsArray(sortedBy property: SortableProperties = .currentPrice) {
        do {
            let coins = try repository.loadLocalCoins(sortedBy: property, ascending: ascendingSortFor(property))
            self.coins = coins
        } catch {
            print("Error")
        }
    }
    
    func ascendingSortFor(_ property: SortableProperties) -> Bool {
        switch property {
        case .marketCapRank:
            return true
        default:
            return false
        }
    }
}
