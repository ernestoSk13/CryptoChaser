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
    func fetchCoins() async throws -> [Currency]
}

class RemoteCryptoService: CryptoService {
    var session: URLSession = URLSession(configuration: .ephemeral)
    let fetchCoinsEnpoint = FetchCoinsEndpoint()
    
    func fetchCoins() async throws -> [Currency] {
        guard let request = fetchCoinsEnpoint.request else {
            throw NetworkError.badRequest
        }
        
        do {
            let (data, response) = try await session.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                throw NetworkError.badResponse
            }
            
            let decoder = JSONDecoder()
            let coins = try decoder.decode([Currency].self, from: data)
            return coins
        } catch {
            throw NetworkError.other(error)
        }
    }
}
