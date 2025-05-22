//
//  FetchCurrencyUseCase.swift
//  CryptoChaser
//
//  Created by Ernesto Sánchez Kuri on 20/05/25.
//

import Foundation

protocol FetchCurrencyUseCase {
    /// Calls the repository to load Core Data results and transform it into Currency objects
    /// - Returns: An Array of Currency objects
    func fetchLocal() throws -> [Currency]
    /// Calls the repository to fetch Currency objects from the server
    /// - Returns: An Array of Currency objects
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
