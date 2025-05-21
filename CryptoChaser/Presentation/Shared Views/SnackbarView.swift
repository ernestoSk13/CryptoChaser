//
//  SnackbarView.swift
//  CryptoChaser
//
//  Created by Ernesto Sánchez Kuri on 21/05/25.
//

import Foundation
import UIKit

final class SnackbarView: UIView {
    private let label = UILabel()
    
    init() {
        super.init(frame: .zero)
        backgroundColor = .darkGray
        layer.cornerRadius = 8
        alpha = 0.0
        
        label.textColor = .white
        label.font = .systemFont(ofSize: 17, weight: .medium)
        label.numberOfLines = 0
        addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12)
        ])
    }
    
    func present(in view: UIView, message: String, duration: TimeInterval = 3) {
        label.text = message
        view.addSubview(self)
        translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            centerXAnchor.constraint(equalTo: view.centerXAnchor),
            bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
        
        UIView.animate(withDuration: 0.25) {
            self.alpha = 1.0
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            self.hide()
        }
    }
    
    func hide() {
        UIView.animate(withDuration: 0.3) {
            self.alpha = 0.0
        } completion: { _ in
            self.removeFromSuperview()
        }

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
