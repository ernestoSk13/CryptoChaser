//
//  Bundle+Extensions.swift
//  CryptoChaser
//
//  Created by Ernesto Sánchez Kuri on 20/05/25.
//

import Foundation

extension Bundle {
    func decode<T: Decodable>(_ type: T.Type, from file: String) -> T {
        guard let url = self.url(forResource: file, withExtension: nil) else {
            fatalError("Wrong file location")
        }
        
        guard let data = try? Data(contentsOf: url) else {
            fatalError("Failed to load \(file) from Bundle")
        }
        
        let decoder = JSONDecoder()
        
        do {
            let loaded = try decoder.decode(T.self, from: data)
            return loaded
        } catch {
            fatalError("Couldn't decode file \(error)")
        }
    }
}
