//
//  FetchCurrencyUseCase.swift
//  CryptoChaser
//
//  Created by Ernesto Sánchez Kuri on 20/05/25.
//

import Foundation

protocol FetchCurrencyUseCase {
    func fetchLocal() throws -> [Currency]
    func fetchRemote() async throws -> [Currency]
}

final class DefaultFetchCurrencyUseCase: FetchCurrencyUseCase {
    let repository: CryptoRepository
    
    init(repository: CryptoRepository) {
        self.repository = repository
    }
    
    func fetchLocal() throws -> [Currency] {
        try repository.loadLocalCoins()
    }
    
    func fetchRemote() async throws -> [Currency] {
        try await repository.fetchCoins()
    }
}
