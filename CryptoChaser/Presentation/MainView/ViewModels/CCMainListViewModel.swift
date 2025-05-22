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

enum SortingOption: String, CaseIterable {
    case name
    case price
    case marketCapRank
}

final class CCMainListViewModel: ObservableObject {
    // Use case for fetching an array of currencies
    private let fetchUseCase: FetchCurrencyUseCase
    // User case for searching a currency by it's name
    private let searchUseCase: SearchCurrencyUseCase
    @Published private(set) var coins: [Currency] = []
    @Published private(set) var errorString: String = ""
    private let logger = Logger()
    // Navigation handler that will be managed in the App Coordinator
    private let navigationHandler: (Currency) -> Void
    @Published var sortingOption: SortingOption = .marketCapRank
    @Published var ascendingOrder: Bool = true
    
    init(fetchUseCase: FetchCurrencyUseCase, searchUseCase: SearchCurrencyUseCase, navigationHandler: @escaping (Currency) -> Void) {
        self.fetchUseCase = fetchUseCase
        self.searchUseCase = searchUseCase
        self.navigationHandler = navigationHandler
    }
    
    ///  Fetch coins using the `fetchUseCase`, returns an array of `Currency`. Throws an error if fails. Once the concurrent function finishes it returns to the main actor without compromising the UI
    @MainActor
    func fetchCoins() async throws {
        do {
            // Load locally first
            let localCoins = try fetchUseCase.fetchLocal()
            self.coins = localCoins
            sortCurrencies()
            //After fetching from core data, fetch from the service
            let coins = try await fetchUseCase.fetchRemote()
            self.coins = coins
            sortCurrencies()
        } catch let localError as CoreDataError {
            errorString = "There was an error fetching the coins, try again later."
            throw CoinFetchError.networkError(localError)
        } catch let networkError  {
            errorString = "There was an error fetching the coins, try again later."
            throw CoinFetchError.networkError(networkError)
        }
        
    }
    
    func sortCurrencies(_ sortedOption: SortingOption? = nil) {
        ascendingOrder = sortedOption == sortingOption && sortedOption != nil ? !ascendingOrder : ascendingOrder
        sortingOption = sortedOption ?? self.sortingOption
        coins.sort(by: { c1, c2 in
            switch sortingOption {
            case .name:
                return ascendingOrder ? c1.name < c2.name : c1.name > c2.name
            case .price:
                return ascendingOrder ? c1.currentPrice < c2.currentPrice : c1.currentPrice > c2.currentPrice
            case .marketCapRank:
                return ascendingOrder ? c1.marketCapRank ?? 0 < c2.marketCapRank ?? 0 : c1.marketCapRank ?? 0 > c2.marketCapRank ?? 0
            }})
    }
    
    func searchCurrency(name: String) {
        do {
            let coins = try searchUseCase.execute(query: name)
            self.coins = coins
        } catch {
            debugPrint("Error searching currency")
        }
    }
    
    func didSelectCurrency(at index: Int) {
        let currency = coins[index]
        navigationHandler(currency)
    }
}

