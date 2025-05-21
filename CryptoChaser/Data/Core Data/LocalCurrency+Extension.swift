//
//  LocalCurrency+Extension.swift
//  CryptoChaser
//
//  Created by Ernesto Sánchez Kuri on 21/05/25.
//

import CoreData

extension LocalCurrency {
    func toRemoteModel() -> Currency {
        guard let id = self.id,
              let name = self.name,
              let image = self.image,
              let lastUpdated = self.lastUpdated,
              let symbol = self.symbol else {
            fatalError("Local object is not valid, missing required attributes")
        }
        
        return Currency(id: id,
                        symbol: symbol,
                        name: name,
                        image: image,
                        currentPrice: self.currentPrice,
                        marketCap: self.marketCap,
                        marketCapRank: self.marketCapRank,
                        totalVolume: self.totalVolume,
                        high24: self.high24,
                        low24: self.low24,
                        priceChange24h: self.priceChange24h,
                        lastUpdated: lastUpdated)
    }
}

extension Currency {
    func toEntity(in context: NSManagedObjectContext) -> LocalCurrency {
        let localCurrency = LocalCurrency(context: context)
        localCurrency.id = self.id
        localCurrency.name = self.name
        localCurrency.lastUpdated = self.lastUpdated
        localCurrency.image = self.image
        localCurrency.currentPrice = self.currentPrice
        localCurrency.high24 = self.high24 ?? 0
        localCurrency.low24 = self.low24 ?? 0
        localCurrency.totalVolume = self.totalVolume ?? 0
        localCurrency.marketCap = self.marketCap ?? 0
        localCurrency.marketCapRank = self.marketCapRank ?? 0
        localCurrency.priceChange24h = self.priceChange24h ?? 0
        localCurrency.symbol = self.symbol
        return localCurrency
    }
}
