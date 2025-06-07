//
//  CoinCollectionViewCell.swift
//  CryptoChaser
//
//  Created by Ernesto Sánchez Kuri on 06/06/25.
//

import Foundation
import UIKit

final class CurrencyCellView: UICollectionViewCell {
    static let identifier = "CoinCell"
    
    private lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var title: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .headline)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var symbol: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .subheadline)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var lastUpdated: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .subheadline)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var price: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .headline)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var detailStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [title, symbol, lastUpdated])
        stack.axis = .vertical
        stack.spacing = 12
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        contentView.addSubview(imageView)
        contentView.addSubview(detailStack)
        contentView.addSubview(price)
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            imageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 40),
            imageView.widthAnchor.constraint(equalToConstant: 40),
            detailStack.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 12),
            detailStack.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            price.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            price.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
        
        contentView.backgroundColor = UIColor(named: "secondaryBg")
        contentView.layer.masksToBounds = true
        contentView.layer.cornerRadius = 7
        contentView.layer.borderWidth = 0.3
        contentView.layer.borderColor = UIColor.clear.cgColor
        contentView.layer.masksToBounds = true
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        self.layer.shadowRadius = 2.0
        self.layer.shadowOpacity = 1.0
        self.layer.masksToBounds = false
        self.layer.shadowPath = UIBezierPath(roundedRect:self.bounds, cornerRadius: contentView.layer.cornerRadius).cgPath
    }
    
    func configure(with viewModel: CurrencyCellViewModel) {
        Task {
            do {
                let image = try await ImageLoader().fetchCurrencyLogo(url: viewModel.imageURL)
                imageView.image = image
            } catch {
                imageView.image = UIImage(systemName: "bitcoinsign.ring.dashed")
            }
        }
        title.text = viewModel.symbol
        symbol.text = viewModel.name
        lastUpdated.text = "Last update: \(viewModel.lastUpdated)"
        price.text = viewModel.price
        // Accessibility
        contentView.accessibilityLabel = viewModel.name
        contentView.accessibilityValue = viewModel.price
        contentView.accessibilityIdentifier = Constants.Accessibility.MainList.Row.identifier.replacingOccurrences(of: "$1", with: viewModel.currencyIdentifier)
    }
}
