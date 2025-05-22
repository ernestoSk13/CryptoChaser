//
//  CCMainListViewModelTests.swift
//  CryptoChaserTests
//
//  Created by Ernesto Sánchez Kuri on 21/05/25.
//

import Testing
@testable import CryptoChaser

struct CCMainListViewModelTests {
    let service = CryptoServiceStub()
    let repository = MockCryptoRepository()
    
    @Test func testFetchCoinsReturnArrayOfCurrencies() async throws {
        let fetchUseCase = DefaultFetchCurrencyUseCase(repository: repository)
        let searchUseCase = DefaultSearchCurrencyUseCase(repository: repository)
        let viewModel = CCMainListViewModel(fetchUseCase: fetchUseCase,
                                            searchUseCase: searchUseCase) { _ in
            
        }
        try await viewModel.fetchCoins()
        #expect(viewModel.coins.count == 20)
        #expect(viewModel.coins.first?.id == "bitcoin")
    }
    
    @Test func testSearchCoinsReturnASingleElementArray() async throws {
        let fetchUseCase = DefaultFetchCurrencyUseCase(repository: repository)
        let searchUseCase = DefaultSearchCurrencyUseCase(repository: repository)
        let viewModel = CCMainListViewModel(fetchUseCase: fetchUseCase,
                                            searchUseCase: searchUseCase) { _ in
            
        }
        try await viewModel.fetchCoins()
        viewModel.searchCurrency(name: "Hedera")
        #expect(!viewModel.coins.isEmpty)
        #expect(viewModel.coins.count == 1)
        #expect(viewModel.coins.first?.id == "hedera-hashgraph")
    }

}
