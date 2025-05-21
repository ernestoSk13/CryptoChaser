//
//  CCMainListViewModel.swift
//  CryptoChaser
//
//  Created by Ernesto Sánchez Kuri on 20/05/25.
//

import Foundation
import Combine
import OSLog

enum CoinFetchError: Error {
    case networkError(Error)
}

final class CCMainListViewModel: ObservableObject {
    // Use case for fetching an array of currencies
    private let fetchUseCase: FetchCurrencyUseCase
    // User case for searching a currency by it's name
    private let searchUseCase: SearchCurrencyUseCase
    @Published private(set) var coins: [Currency] = []
    @Published private(set) var errorString: String = ""
    private let logger = Logger()
    
    init(fetchUseCase: FetchCurrencyUseCase, searchUseCase: SearchCurrencyUseCase) {
        self.fetchUseCase = fetchUseCase
        self.searchUseCase = searchUseCase
    }
    
    ///  Fetch coins using the `fetchUseCase`, returns an array of `Currency`. Throws an error if fails. Once the concurrent function finishes it returns to the main actor without compromising the UI
    @MainActor
    func fetchCoins() async throws {
        do {
            let coins = try await fetchUseCase.execute()
            self.coins = coins
        } catch {
            errorString = "There was an error fetching the coins, try again later."
            throw CoinFetchError.networkError(error)
        }
        
    }
}
