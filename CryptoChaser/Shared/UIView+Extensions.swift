//
//  UIView+Extensions.swift
//  CryptoChaser
//
//  Created by Ernesto Sánchez Kuri on 22/05/25.
//

import UIKit

extension UIView {
    static func makeDivider() -> UIView {
        let divider = UIView()
        divider.backgroundColor = .systemGray6
        divider.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            divider.heightAnchor.constraint(equalToConstant: 1)
        ])
        return divider
    }
}
