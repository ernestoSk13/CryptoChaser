//
//  CryptoRepository.swift
//  CryptoChaser
//
//  Created by Ernesto Sánchez Kuri on 20/05/25.
//

import Foundation

protocol CryptoRepository {
    /// Makes a fetch to Core Data and returns an array of transformed Currency objects.
    /// - Returns: an Array of Currency objects.
    func loadLocalCoins() throws -> [Currency]
    /// Makes a fetch to the remote server and returns an array of Currency objects.
    /// - Returns:an Array of Currency objects.
    func fetchCoins() async throws -> [Currency]
    func searchCurrency(name: String) throws -> [Currency]
}

final class MockCryptoRepository: CryptoRepository {
    let mockService: CryptoServiceStub = CryptoServiceStub()
    private let local: CurrencyCoreDataStorage = CurrencyCoreDataStorage()
    
    func loadLocalCoins() throws -> [Currency] {
        let localElements = try local.fetchAllCoins()
        return localElements.map { $0.toRemoteModel() }
    }
    
    func fetchCoins() async throws -> [Currency] {
        return try await mockService.fetchCoins()
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
    
    func loadLocalCoins() throws -> [Currency] {
        let localElements = try local.fetchAllCoins()
        return localElements.map { $0.toRemoteModel() }
    }
    
    func fetchCoins() async throws -> [Currency] {
        let remoteCoins = try await service.fetchCoins()
        try await local.saveCurrencies(remoteCoins)
        return remoteCoins
    }
    
    func searchCurrency(name: String) throws -> [Currency] {
        let localCoins = try local.searchCurrency(name: name)
        return localCoins.map { $0.toRemoteModel() }
    }
}
