//
//  CryptoService.swift
//  CryptoChaser
//
//  Created by Ernesto Sánchez Kuri on 20/05/25.
//

import Foundation

protocol CryptoService {
    var session: URLSession { get set }
    func fetchCoins() async throws -> [Currency]
}

class RemoteCryptoService: CryptoService {
    var session: URLSession = .shared
    
    func fetchCoins() async throws -> [Currency] {
        return []
    }
}
