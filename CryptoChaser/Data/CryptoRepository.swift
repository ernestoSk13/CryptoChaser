//
//  CryptoRepository.swift
//  CryptoChaser
//
//  Created by Ernesto Sánchez Kuri on 20/05/25.
//

import Foundation

protocol CryptoRepository {
    /// Makes a fetch to the remote server and returns an array of Currency objects.
    /// - Parameter cached: a closure that will return the Core Data objects stored.
    /// - Returns:an Array of Currency objects.
    func fetchCoins(cached: @escaping (([Currency]) -> ())) async throws -> [Currency]
    func searchCurrency(name: String) throws -> [Currency]
}

final class MockCryptoRepository: CryptoRepository {
    let mockService: CryptoServiceStub = CryptoServiceStub()
    private let local: CurrencyCoreDataStorage = CurrencyCoreDataStorage(coreDataManager: MockCoreDataManager.shared)
    
    /// Makes a fetch to Core Data and returns an array of transformed Currency objects.
    /// - Returns: an Array of Currency objects.
    private func loadLocalCoins() throws -> [Currency] {
        let localElements = try local.fetchAllCoins()
        return localElements.map { $0.toRemoteModel() }
    }
    
    func fetchCoins(cached: @escaping (([Currency]) -> ())) async throws -> [Currency] {
        let localCoins = try loadLocalCoins()
        cached(localCoins)
        let coins = try await mockService.fetchCoins()
        try await local.saveCurrencies(coins)
        return coins
    }
    
    func searchCurrency(name: String) throws -> [Currency] {
        let localCoins = try local.searchCurrency(name: name)
        return localCoins.map { $0.toRemoteModel() }
    }
}

final class DefaultCryptoRepository: CryptoRepository {
    private let service: CryptoService
    private let local: CurrencyCoreDataStorage
    
    init(service: CryptoService, local: CurrencyCoreDataStorage) {
        self.service = service
        self.local = local
    }
    
    /// Makes a fetch to Core Data and returns an array of transformed Currency objects.
    /// - Returns: an Array of Currency objects.
    private func loadLocalCoins() throws -> [Currency] {
        let localElements = try local.fetchAllCoins()
        return localElements.map { $0.toRemoteModel() }
    }
    
    func fetchCoins(cached: @escaping (([Currency]) -> ())) async throws -> [Currency] {
        let localCoins = try loadLocalCoins()
        cached(localCoins)
        let remoteCoins = try await service.fetchCoins()
        try await local.saveCurrencies(remoteCoins)
        return remoteCoins
    }
    
    func searchCurrency(name: String) throws -> [Currency] {
        let localCoins = try local.searchCurrency(name: name)
        return localCoins.map { $0.toRemoteModel() }
    }
}
