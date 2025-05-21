//
//  CryptoRepository.swift
//  CryptoChaser
//
//  Created by Ernesto Sánchez Kuri on 20/05/25.
//

import Foundation

protocol CryptoRepository {
    func fetchCoins() async throws -> [Currency]
    func searchCurrency(name: String) async throws -> [Currency]
}

final class DefaultCryptoRepository: CryptoRepository {
    private let service: CryptoService
    
    init(service: CryptoService) {
        self.service = service
    }
    
    func fetchCoins() async throws -> [Currency] {
        try await service.fetchCoins()
    }
    
    func searchCurrency(name: String) async throws -> [Currency] {
        return []
    }
}
