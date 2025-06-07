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

final class CryptoListViewModel: ObservableObject {
    private let repository: CryptoRepository
    @Published private(set) var coins: [Currency] = []
    @Published private(set) var errorString: String = ""
    private let logger = Logger()
    // Navigation handler that will be managed in the App Coordinator
    private let navigationHandler: (Currency) -> Void
    @Published var sortingOption: SortingOption = .marketCapRank
    @Published var ascendingOrder: Bool = true
    
    init(repository: CryptoRepository, navigationHandler: @escaping (Currency) -> Void) {
        self.navigationHandler = navigationHandler
        self.repository = repository
    }
    
    ///  Fetch coins using the `fetchUseCase`, returns an array of `Currency`. Throws an error if fails. Once the concurrent function finishes it returns to the main actor without compromising the UI
    @MainActor
    func fetchCoins() async throws {
        do {
            let coins = try await repository.fetchCoins { localCoins in
                self.coins = self.sort(currencies: localCoins)
            }
            self.coins = sort(currencies: coins)
        } catch let localError as CoreDataError {
            errorString = "There was an error fetching the coins, try again later."
            throw CoinFetchError.networkError(localError)
        } catch let networkError {
            errorString = "There was an error fetching the coins, try again later."
            throw CoinFetchError.networkError(networkError)
        }
    }
    
    func sort(currencies: [Currency], _ sortedOption: SortingOption? = nil) -> [Currency] {
        ascendingOrder = sortedOption == sortingOption && sortedOption != nil ? !ascendingOrder : ascendingOrder
        sortingOption = sortedOption ?? self.sortingOption
        var sorted = currencies
        sorted.sort(by: { c1, c2 in
            switch sortingOption {
            case .name:
                return ascendingOrder ? c1.name < c2.name : c1.name > c2.name
            case .price:    
                return ascendingOrder ? c1.currentPrice < c2.currentPrice : c1.currentPrice > c2.currentPrice
            case .marketCapRank:
                return ascendingOrder ? c1.marketCapRank ?? 0 < c2.marketCapRank ?? 0 : c1.marketCapRank ?? 0 > c2.marketCapRank ?? 0
            }})
        
        return sorted
    }
    
    func sortCurrencies( _ sortedOption: SortingOption? = nil) {
        self.coins = sort(currencies: coins, sortedOption)
    }
    
    func searchCurrency(name: String) {
        do {
            let coins = try repository.searchCurrency(name: name)
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

