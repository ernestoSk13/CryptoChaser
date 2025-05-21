//
//  Constants.swift
//  CryptoChaser
//
//  Created by Ernesto Sánchez Kuri on 20/05/25.
//

import Foundation

enum Constants {
    enum Network {
        static let baseURLString = "https://api.coingecko.com/api/v3"
        static let fetchLimit: Int = 20
    }
    
    enum Accessibility {
        enum MainList {
            static let label = "Currency Table View"
            static let identifier = "main-table-view"
            enum Row {
                static let identifier = "CurrencyCell_$1"
                static let value = "Currency price is $1"
            }
        }
    }
}
