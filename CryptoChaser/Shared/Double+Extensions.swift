//
//  Double+Extensions.swift
//  CryptoChaser
//
//  Created by Ernesto Sánchez Kuri on 20/05/25.
//

import Foundation

extension Double {
    func formatCurrency() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = 2
        formatter.locale = Locale.current
        return formatter.string(from: NSNumber(value: self)) ?? "$0.00"
    }
    
    func formatBigNumber() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = ","
        return formatter.string(from: NSNumber(value: self)) ?? "\(self)"
    }
    
    func shortName() -> String {
        let num = abs(self)
        let sign = self < 0 ? "-" : ""
        
        switch num {
        case 1_000_000_000...:
            return "\(sign)\(String(format: "%.2f", num / 1_000_000_000))B"
        case 1_000_000...:
            return "\(sign)\(String(format: "%.2f", num / 1_000_000))M"
        case 1_000...:
            return "\(sign)\(String(format: "%.2f", num / 1_000))K"
        default:
            return "\(sign)\(String(format: "%.2f", num))"
        }
    }
    
    func rounded(toPlaces places: Int) -> String {
        let divisor = pow(10.0, Double(places))
        let rounded = (self * divisor).rounded() / divisor
        return String(format: "%\(places)2f", rounded)
    }
}
