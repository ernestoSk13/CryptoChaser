//
//  SearchCurrencyUseCase.swift
//  CryptoChaser
//
//  Created by Ernesto Sánchez Kuri on 20/05/25.
//

import Foundation

protocol SearchCurrencyUseCase {
    func execute(query: String) throws -> [Currency]
}

final class DefaultSearchCurrencyUseCase: SearchCurrencyUseCase {
    let repository: CryptoRepository
    
    init(repository: CryptoRepository) {
        self.repository = repository
    }
    
    func execute(query: String) throws -> [Currency] {
        let coins = try repository.searchCurrency(name: query)
        return coins
    }
}
