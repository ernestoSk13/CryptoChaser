//
//  ImageLoader.swift
//  CryptoChaser
//
//  Created by Ernesto Sánchez Kuri on 22/05/25.
//

import Foundation
import SwiftUI

enum ImageLoaderError: Error {
    case invalidData
}

actor ImageLoader {
    private var cache: URLCache = .shared
    private var images: [URLRequest: LoaderStatus] = [:]
    
    public func fetch(_ url: URL) async throws -> UIImage? {
        return try await fetchCurrencyLogo(url: url)
    }
    
    func fetchCurrencyLogo(url: URL) async throws -> UIImage? {
        
        let request = URLRequest(url: url)
        if let existingData = cache.cachedResponse(for: request)?.data {
            return UIImage(data: existingData)
        }
        
        if let status = images[request] {
            switch status {
            case .fetched(let img):
                return img
            case .inProgress(let task):
                return try await task.value
            }
        }
        
        
        let task: Task<UIImage, Error> = Task {
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let image = UIImage(data: data) else {
                throw ImageLoaderError.invalidData
            }
            let cachedData = CachedURLResponse(response: response, data: data)
            cache.storeCachedResponse(cachedData, for: request)
            return image
        }
        
        images[request] = .inProgress(task)
        
        let image = try await task.value
        
        images[request] = .fetched(image)
        
        return image
    }
    
    
    private enum LoaderStatus {
        case inProgress(Task<UIImage, Error>)
        case fetched(UIImage)
    }
}


struct ImageLoaderKey: EnvironmentKey {
    static let defaultValue = ImageLoader()
}

extension EnvironmentValues {
    var imageLoader: ImageLoader {
        get { self[ImageLoaderKey.self] }
        set { self[ImageLoaderKey.self ] = newValue}
    }
}
