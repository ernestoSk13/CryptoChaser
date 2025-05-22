//
//  ImageLoader.swift
//  CryptoChaser
//
//  Created by Ernesto Sánchez Kuri on 21/05/25.
//

import Foundation
import SwiftUI
import Combine

struct ImageLoaderKey: EnvironmentKey {
    static let defaultValue = ImageLoader()
}

extension EnvironmentValues {
    var imageLoader: ImageLoader {
        get { self[ImageLoaderKey.self] }
        set { self[ImageLoaderKey.self ] = newValue}
    }
}

enum ImageLoaderError: Error {
    case failedToLoad
}

actor ImageLoader {
    private var images: [URL: LoaderStatus] = [:]
    
    
    public func fetch(_ url: URL) async throws -> UIImage? {
        return try await fetchCurrencyImage(url: url)
    }
    
    func fetchCurrencyImage(url: URL) async throws -> UIImage? {
        let request = URLRequest(url: url)
        if let status = images[url] {
            switch status {
            case .fetched(let img):
                return img
            case .inProgress(let task):
                return try await task.value
            }
        }
        
        
        let task: Task<UIImage, Error> = Task {
            let (data, _) = try await URLSession.shared.data(for: request)
            guard let image = UIImage(data: data) else {
                throw ImageLoaderError.failedToLoad
            }
            return image
        }
        
        images[url] = .inProgress(task)
        
        let image = try await task.value
        
        images[url] = .fetched(image)
        
        return image
    }
    
    
    private enum LoaderStatus {
        case inProgress(Task<UIImage, Error>)
        case fetched(UIImage)
    }
}
