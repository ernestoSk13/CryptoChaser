//
//  FetchCoinsEndpoint.swift
//  CryptoChaser
//
//  Created by Ernesto Sánchez Kuri on 20/05/25.
//

import Foundation

struct FetchCoinsEndpoint {
    private let endpointPath: String = "/coins/markets"
    private var queryItems: [URLQueryItem] = [
        URLQueryItem(name: "vs_currency", value: "usd"),
        URLQueryItem(name: "per_page", value: "\(Constants.Network.fetchLimit)")
    ]
    
    var request: URLRequest? {
        let path = Constants.Network.baseURLString.appending(endpointPath)
        guard let url = URL(string: path), var components = URLComponents(url: url, resolvingAgainstBaseURL: true) else { return nil }
        components.queryItems = components.queryItems.map {
            $0 + queryItems
        } ?? queryItems
    
        var urlRequest = URLRequest(url: components.url ?? url)
        urlRequest.httpMethod = "GET"
        urlRequest.timeoutInterval = 10
        
        return urlRequest
    }
}
