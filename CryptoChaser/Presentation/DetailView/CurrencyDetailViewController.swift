//
//  CurrencyDetailViewController.swift
//  CryptoChaser
//
//  Created by Ernesto Sánchez Kuri on 20/05/25.
//

import Foundation
import SDWebImage
import UIKit


final class CurrencyDetailViewController: UIViewController {
    private let viewModel: CurrencyDetailViewModel
    private let viewIdentifier = "detail_view"
    
    private let currencyLogo: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.heightAnchor.constraint(equalToConstant: 60),
            imageView.widthAnchor.constraint(equalToConstant: 60)
        ])
        return imageView
    }()
    
    private let currencyNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .boldSystemFont(ofSize: 20)
        return label
    }()
    
    private lazy var topStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [currencyLogo, currencyNameLabel])
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = 20
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    // Details
    private let detailStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 10
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    init(viewModel: CurrencyDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Details"
        setupUI()
        configureViewWithCurrency()
    }
    
    func setupUI() {
        //view.addSubview(closeButton)
        view.addSubview(topStack)
        view.addSubview(detailStack)
        NSLayoutConstraint.activate([
            topStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            topStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            detailStack.topAnchor.constraint(equalTo: topStack.safeAreaLayoutGuide.bottomAnchor, constant: 20),
            detailStack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            detailStack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20)
        ])
    }
    
    func configureViewWithCurrency() {
        currencyLogo.sd_setImage(with: viewModel.imageUrl,
                                 placeholderImage: UIImage(systemName: "bitcoinsign.circle"))
        currencyNameLabel.text = viewModel.name
        fillDetailsStack()
    }
    
    func fillDetailsStack() {
        let totalVolumeCell = DetailCellView()
        totalVolumeCell.setupWith(title: "Total Volume", value: viewModel.totalVolume)
        detailStack.addArrangedSubview(totalVolumeCell)
        
        let highPriceCell = DetailCellView()
        highPriceCell.setupWith(title: "Highest Price", value: viewModel.highestPrice)
        let lowestPriceCell = DetailCellView()
        lowestPriceCell.setupWith(title: "Lowest Price", value: viewModel.lowestPrice)
        detailStack.addArrangedSubview(highPriceCell)
        detailStack.addArrangedSubview(lowestPriceCell)
        
        let priceChangeCell = DetailCellView()
        priceChangeCell.setupWith(title: "Price change", value: viewModel.priceChange)
        detailStack.addArrangedSubview(priceChangeCell)
        
        let marketCapCell = DetailCellView()
        marketCapCell.setupWith(title: "Market cap", value: viewModel.marketCap)
        detailStack.addArrangedSubview(marketCapCell)
    }
    
    @objc func closeModal() {
        self.dismiss(animated: true)
    }
}
