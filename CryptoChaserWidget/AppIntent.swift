//
//  AppIntent.swift
//  CryptoChaserWidget
//
//  Created by Ernesto Sánchez Kuri on 09/06/25.
//

import WidgetKit
import AppIntents

struct ConfigurationAppIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource { "Select a currency" }
    static var description: IntentDescription { "Selects a currency to display information for" }

    // An example configurable parameter.
    @Parameter(title: "Currency")
    var selectedCurrency: CurrencyDetail?
    
    init(selectedCurrency: CurrencyDetail) {
        self.selectedCurrency = selectedCurrency
    }
    
    init() {
        
    }
}

struct CurrencyDetail: AppEntity {
    let id: String
    let symbol: String
    var image: URL?
    let name: String
    let currentPrice: String
    let lastUpdate: String
    
    
    static var typeDisplayRepresentation: TypeDisplayRepresentation = "Currency"
    static var defaultQuery: CurrencyQuery = CurrencyQuery()
    
    var displayRepresentation: DisplayRepresentation {
        DisplayRepresentation(title: "\(name) (\(symbol))")
    }
    
    static func allCurrencies() -> [CurrencyDetail] {
        let dataStack = CoreDataManager.shared
        let coreDataManager = CurrencyCoreDataStorage(coreDataManager: dataStack)
        guard let currencies = try? coreDataManager.fetchAllCoins() else {
            return []
        }
        let transformedCurrencies = currencies.map {
            $0.toRemoteModel()
        }.map {
            CurrencyDetail(id: $0.id,
                           symbol: $0.symbol,
                           image: $0.image,
                           name: $0.name,
                           currentPrice: $0.currentPrice.formatCurrency(),
                           lastUpdate: $0.lastUpdatedDate?.hourAndMinute ?? "")
        }
        
        return transformedCurrencies
    }
}

struct CurrencyQuery: EntityQuery {
    func entities(for identifiers: [CurrencyDetail.ID]) async throws -> [CurrencyDetail] {
        CurrencyDetail.allCurrencies().filter { currency in
            return identifiers.contains(currency.id)
        }
    }
    
    func suggestedEntities() async throws -> [CurrencyDetail] {
        guard CurrencyDetail.allCurrencies().count > 0 else {
            return []
        }
        return CurrencyDetail.allCurrencies()
    }
    
    func defaultResult() async -> CurrencyDetail? {
        try? await suggestedEntities().first
    }
}
