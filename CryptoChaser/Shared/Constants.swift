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
            static let label = "Currency Collection View"
            static let identifier = "main-collection-view"
            enum Row {
                static let identifier = "CurrencyCell_$1"
                static let value = "Currency price is $1"
            }
            enum SearchBar {
                enum TextField {
                    static let label = "Search Bar"
                    static let identifier = "main-collection-view-search-bar"
                }
                enum CancelButton {
                    static let label = "Cancel Button"
                    static let identifier = "main-collection-view-search-bar-cancel-button"
                }
            }
        }
    }
    
    static let defaultPadding: CGFloat = 12
    static let cellSize: CGFloat = 12
}
