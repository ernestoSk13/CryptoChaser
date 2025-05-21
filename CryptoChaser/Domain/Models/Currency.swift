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
    }
}
