//
//  CryptoContentView.swift
//  CryptoChaser
//
//  Created by Ernesto Sánchez Kuri on 06/06/25.
//

import Foundation
import UIKit

final class CryptoContentView: UIView, UIContentView {
    var configuration: UIContentConfiguration
    
    private lazy var title: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var contentDescription: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var labelStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [title, contentDescription])
        stack.axis = .vertical
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    init(configuration: UIContentConfiguration) {
        self.configuration = configuration
        super.init(frame: .zero)
        setupUI()
        apply(configuration)
    }
    
    func setupUI() {
        addSubview(title)
        addSubview(contentDescription)
        NSLayoutConstraint.activate([
            labelStack.centerXAnchor.constraint(equalTo: centerXAnchor),
            labelStack.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func apply(_ configuration: UIContentConfiguration) {
        
    }
}

struct StateConfiguration: UIContentConfiguration {
    var title = ""
    var contentDescription = ""
    
    func makeContentView() -> any UIView & UIContentView {
        return CryptoContentView(configuration: self)
    }
    
    func updated(for state: any UIConfigurationState) -> StateConfiguration {
        return self
    }
    
    
}
