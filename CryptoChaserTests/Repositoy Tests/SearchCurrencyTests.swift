//
//  SearchCurrencyTests.swift
//  CryptoChaserTests
//
//  Created by Ernesto Sánchez Kuri on 21/05/25.
//

import Testing
@testable import CryptoChaser

struct SearchCurrencyTests {
    let service = CryptoServiceStub()
    let repository = MockCryptoRepository()
    
    lazy var viewModel: CryptoListViewModel = {
        CryptoListViewModel(repository: repository) { _ in
            
        }
    }()
    
    @Test func testSearchCurrencyReturnsOneElement() async throws {
        _ = try await repository.fetchCoins(cached: { _ in
            
        })
        let hederaCurrency = try repository.searchCurrency(name: "Hedera")
        #expect(hederaCurrency.count == 1)
    }
    
    @Test func testSearchCurrencyReturnsNoElement() async throws {
        _ = try await repository.fetchCoins(cached: { _ in
            
        })
        let nonExistingElement = try repository.searchCurrency(name: "Lorem Ipsum").first
        #expect(nonExistingElement == nil)
    }
    
    @Test func testSearchCurrencyReturnsAllElements() async throws {
        _ = try await repository.fetchCoins(cached: { _ in
            
        })
        let allElements = try repository.searchCurrency(name: "")
        #expect(allElements.count == 20)
    }
    
    @Test func testSearchCurrencyReturnMultipleElements() async throws {
        _ = try await repository.fetchCoins(cached: { _ in
            
        })
        let allCurrencies = try repository.searchCurrency(name: "B")
        #expect(allCurrencies.count > 1)
    }
}
