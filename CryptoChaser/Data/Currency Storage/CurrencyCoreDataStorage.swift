//
//  CurrencyCoreDataStorage.swift
//  CryptoChaser
//
//  Created by Ernesto Sánchez Kuri on 21/05/25.
//

import Foundation
import CoreData

final class CurrencyCoreDataStorage {
    private let coreDataManager: CoreDataManager
    
    init(coreDataManager: CoreDataManager = CoreDataManager.shared) {
        self.coreDataManager = coreDataManager
    }
    
    /// Makes a fetch request for a specific currency using it's ID. If it's not found returns nil
    /// - Parameter id: a String that represents the currency identifier
    /// - Returns: an optional LocalCurrency entity
    func fetchCurrency(id: String) throws -> LocalCurrency? {
        let request: NSFetchRequest = LocalCurrency.fetchRequest()
        let sort = NSSortDescriptor.init(key: "marketCapRank", ascending: true)
        request.sortDescriptors = [sort]
        request.predicate = NSPredicate(format: "id == %@", id)
        let currencies = try coreDataManager.performFetchRequest(request)
        return currencies.first
    }
    
    /// Makes a fetch request with a query sent from the search controller. the results are compared with the LocalCurrency name
    /// - Parameter query: a String that represents the name query
    /// - Returns: a NSFetchRequest that will be used view the context
    func fetchCoinsRequest(_ query: String = "") -> NSFetchRequest<LocalCurrency> {
        let request: NSFetchRequest = LocalCurrency.fetchRequest()
        let sort = NSSortDescriptor.init(key: "marketCapRank", ascending: true)
        request.sortDescriptors = [sort]
        if !query.isEmpty {
            request.predicate = NSPredicate(format: "name CONTAINS[c] %@", query)
        }
        return request
    }
    
    /// Makes a general search for all the LocalCurrency objects.
    /// - Returns: an Array of LocalCurrency objects
    func fetchAllCoins() throws -> [LocalCurrency] {
        let request = fetchCoinsRequest()
        return try coreDataManager.performFetchRequest(request)
    }
    
    /// Makes a fetch requests with a name query. Throws an error if the fetch fails.
    /// - Parameter name: a String that represents the name query
    /// - Returns: an Array of LocalCurrency objects
    func searchCurrency(name: String) throws -> [LocalCurrency] {
        let request = fetchCoinsRequest(name)
        let viewContext = coreDataManager.context
        let currencies = try viewContext.fetch(request)
        return currencies
    }
    
    /// Makes an insertion or an update to the `LocalCurrency` objects from the remote Currency objects. It is done in a background context asynchronously
    /// - Parameter currencies: an Array of `Currency` objects
    func saveCurrencies(_ currencies: [Currency]) async throws {
        let viewContext = coreDataManager.context
        let bgContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        bgContext.parent = viewContext
        
        try await bgContext.perform {
            for currency in currencies {
                let fetchRequest: NSFetchRequest<LocalCurrency> = LocalCurrency.fetchRequest()
                fetchRequest.predicate = NSPredicate(format: "id == %@", currency.id)
                if let existing = try? bgContext.fetch(fetchRequest).first {
                    existing.id = currency.id
                    existing.name = currency.name
                    existing.currentPrice = currency.currentPrice
                    existing.image = currency.image
                    existing.symbol = currency.symbol
                    existing.high24 = currency.high24 ?? 0
                    existing.low24 = currency.low24 ?? 0
                    existing.marketCap = currency.marketCap ?? 0
                    existing.lastUpdated = currency.lastUpdated
                    existing.totalVolume = currency.totalVolume ?? 0
                    existing.priceChange24h = currency.priceChange24h ?? 0
                    try bgContext.save()
                } else {
                    _ = currency.toEntity(in: viewContext)
                    try bgContext.save()
                }
            }
        }
        
        try await viewContext.perform {
            try viewContext.save()
        }
    }
}
