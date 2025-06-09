//
//  AppGroup.swift
//  CryptoChaser
//
//  Created by Ernesto Sánchez Kuri on 09/06/25.
//

import Foundation

public enum AppGroup: String {
    case cryptoChaser = "group.app.cryptochaser"
    
    var oldStoreURL: URL? {
        let directory = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first
        return directory?.appending(path: "DataModel")
    }
    
    public var containerURL: URL? {
        switch self {
        case .cryptoChaser:
            return FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: self.rawValue)
        }
    }
}
