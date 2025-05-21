//
//  CryptoServiceTests.swift
//  CryptoChaserTests
//
//  Created by Ernesto Sánchez Kuri on 20/05/25.
//

import Testing
@testable import CryptoChaser

struct CryptoServiceTests {
    let cryptoService = CryptoServiceStub()
    
    @Test func testFetchCoinsReturnArrayWithTwentyElements() async throws {
        let coins = try await cryptoService.fetchCoins()
        #expect(coins.isEmpty == false)
        #expect(coins.count == 20)
    }
}
