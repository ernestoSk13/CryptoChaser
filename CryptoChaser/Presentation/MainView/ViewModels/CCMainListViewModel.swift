//
//  CCMainListViewModel.swift
//  CryptoChaser
//
//  Created by Ernesto Sánchez Kuri on 20/05/25.
//

import Foundation
import Combine

final class CCMainListViewModel: ObservableObject {
    // Use case for fetching an array of currencies
    let fetchUseCase: FetchCurrencyUseCase
    // User case for searching a currency by it's name
    let searchUseCase: SearchCurrencyUseCase
    @Published private(set) var coins: [Currency] = []
    
    init(fetchUseCase: FetchCurrencyUseCase, searchUseCase: SearchCurrencyUseCase) {
        self.fetchUseCase = fetchUseCase
        self.searchUseCase = searchUseCase
    }
}
