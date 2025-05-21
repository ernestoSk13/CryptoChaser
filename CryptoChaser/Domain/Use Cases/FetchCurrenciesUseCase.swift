//
//  FetchCurrencyUseCase.swift
//  CryptoChaser
//
//  Created by Ernesto Sánchez Kuri on 20/05/25.
//

import Foundation

protocol FetchCurrencyUseCase {
    func execute() async throws -> [Currency]
}

final class DefaultFetchCurrencyUseCase: FetchCurrencyUseCase {
    let repository: CryptoRepository
    
    init(repository: CryptoRepository) {
        self.repository = repository
    }
    
    func execute() async throws -> [Currency] {
        return []
    }
}
