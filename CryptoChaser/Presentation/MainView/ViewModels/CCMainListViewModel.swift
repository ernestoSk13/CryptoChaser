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
    @Published private(set) var isLoading: Bool = false
    
    init(fetchUseCase: FetchCurrencyUseCase, searchUseCase: SearchCurrencyUseCase) {
        self.fetchUseCase = fetchUseCase
        self.searchUseCase = searchUseCase
    }
    
    ///  Fetch coins using the `fetchUseCase`, returns an array of `Currency`. Throws an error if fails. Once the concurrent function finishes it returns to the main actor without compromising the UI
    @MainActor
    func fetchCoins() async {
        isLoading = true
        do {
            let coins = try await fetchUseCase.execute()
            self.coins = coins
        } catch {
            print(error.localizedDescription)
        }
        
    }
}
