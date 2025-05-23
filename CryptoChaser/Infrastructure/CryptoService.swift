//
//  CryptoService.swift
//  CryptoChaser
//
//  Created by Ernesto Sánchez Kuri on 20/05/25.
//

import Foundation

enum NetworkError: Error {
    case urlError(URLError)
    case decodingError(Error)
    case badRequest
    case badResponse
    case other(Error)
}

protocol CryptoService {
    var session: URLSession { get set }
    /// Makes a fetch to the server to get an Array of Currency objects
    /// - Returns: An Array of Currency objects.
    func fetchCoins() async throws -> [Currency]
}

class CryptoServiceStub: CryptoService {
    var session: URLSession = URLSession(configuration: .ephemeral)
    
    func fetchCoins() async throws -> [Currency] {
        let currencies = Bundle.main.decode([Currency].self, from: "Coins.json")
        return currencies
    }
}
