//
//  RemoteCryptoService.swift
//  CryptoChaser
//
//  Created by Ernesto Sánchez Kuri on 20/05/25.
//

import Foundation

class RemoteCryptoService: CryptoService {
    // If runned on simulator use ephemeral session. Info here: https://developer.apple.com/forums/thread/777999
    #if targetEnvironment(simulator)
    var session: URLSession = URLSession(configuration: .ephemeral)
    #else
    var session: URLSession = URLSession.shared
    #endif
    
    
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
        } catch let urlError as URLError {
            throw NetworkError.urlError(urlError)
        } catch let decodingError as DecodingError {
            throw NetworkError.decodingError(decodingError)
        }
    }
}
