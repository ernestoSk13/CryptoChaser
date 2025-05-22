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
    
    private var fetchUseCase:FetchCurrencyUseCase {
        DefaultFetchCurrencyUseCase(repository: repository)
    }

    @Test func testSearchCurrencyReturnsOneElement() async throws {
        let searchUseCase = DefaultSearchCurrencyUseCase(repository: repository)
        _ = try await fetchUseCase.fetchRemote()
        let hederaCurrency = try searchUseCase.execute(query: "Hedera")
        #expect(hederaCurrency.count == 1)
    }
    
    @Test func testSearchCurrencyReturnsNoElement() async throws {
        let searchUseCase = DefaultSearchCurrencyUseCase(repository: repository)
        _ = try await fetchUseCase.fetchRemote()
        let hederaCurrency = try searchUseCase.execute(query: "Lorem Ipsum")
        #expect(hederaCurrency.count == 0)
    }
    
    @Test func testSearchCurrencyReturnsAllElements() async throws {
        let searchUseCase = DefaultSearchCurrencyUseCase(repository: repository)
        _ = try await fetchUseCase.fetchRemote()
        let allCurrencies = try searchUseCase.execute(query: "")
        #expect(allCurrencies.count == 20)
    }
    
    @Test func testSearchCurrencyReturnMultipleElements() async throws {
        let searchUseCase = DefaultSearchCurrencyUseCase(repository: repository)
        _ = try await fetchUseCase.fetchRemote()
        let allCurrencies = try searchUseCase.execute(query: "Bi")
        #expect(allCurrencies.count > 1)
    }
}
