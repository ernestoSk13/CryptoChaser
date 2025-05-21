//
//  Currency.swift
//  CryptoChaser
//
//  Created by Ernesto Sánchez Kuri on 20/05/25.
//

import Foundation

struct Currency: Codable {
    let id: String
    let symbol: String
    let name: String
    let image: URL
    let currentPrice: Double
    let marketCap: Double?
    let marketCapRank: Double?
    let totalVolume: Double?
    let high24: Double?
    let low24: Double?
    let priceChange24h: Double?
    private let lastUpdated: String
    
    var lastUpdatedDate: Date? {
        return Date.dateFromString(lastUpdated)
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case symbol
        case name
        case image
        case currentPrice = "current_price"
        case marketCap = "market_cap"
        case marketCapRank = "market_cap_rank"
        case totalVolume = "total_volume"
        case high24 = "high_24h"
        case low24 = "low_24h"
        case priceChange24h = "price_change_24h"
        case lastUpdated = "last_updated"
    }
    
    static let sample: Currency = .init(
        id: "bitcoin",
        symbol: "BTC",
        name: "Bitcoin",
        image: URL(string: "https://coin-images.coingecko.com/coins/images/1/large/bitcoin.png?1696501400")!,
        currentPrice: 103773,
        marketCap: 2060924890542,
        marketCapRank: 1,
        totalVolume: 30326234810,
        high24: 104083,
        low24: 101769,
        priceChange24h: 236.25,
        lastUpdated: "2025-05-21T00:43:44.146Z"
    )
}
