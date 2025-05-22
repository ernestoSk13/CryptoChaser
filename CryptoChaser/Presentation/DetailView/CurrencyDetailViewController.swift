//
//  CurrencyDetailViewController.swift
//  CryptoChaser
//
//  Created by Ernesto Sánchez Kuri on 20/05/25.
//

import Foundation
import SwiftUI
import UIKit


final class CurrencyDetailViewController: UIViewController {
    private let viewModel: CurrencyDetailViewModel
    private let viewIdentifier = "detail_view"
    
    
    private lazy var logoView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 60
        view.layer.masksToBounds = true
        NSLayoutConstraint.activate([
            view.heightAnchor.constraint(equalToConstant: 120),
            view.widthAnchor.constraint(equalToConstant: 120)
        ])
        return view
    }()
    
    private let currencyNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .boldSystemFont(ofSize: 20)
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 17)
        return label
    }()
    
    private lazy var topStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [currencyNameLabel, priceLabel])
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
        view.backgroundColor = .systemGroupedBackground
        title = "Details"
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // Animate logo appearance
        UIView.animate(withDuration: 0.1) { [weak self] in
            self?.logoView.alpha = 1
        }
    }
    
    func setupUI() {
        // Add Remote Image
        let remoteImageView = RemoteImageView(url: viewModel.imageUrl)
            .frame(width: 120, height: 120)
            .shadow(radius: 3)
            .transition(.opacity)
        let hostingViewController = UIHostingController(rootView: remoteImageView)
        hostingViewController.view.backgroundColor = .clear
        hostingViewController.view.translatesAutoresizingMaskIntoConstraints = false
        hostingViewController.view.clipsToBounds = true
        self.addChild(hostingViewController)
        logoView.addSubview(hostingViewController.view)
        NSLayoutConstraint.activate([
            hostingViewController.view.topAnchor.constraint(equalTo: logoView.topAnchor),
            hostingViewController.view.leadingAnchor.constraint(equalTo: logoView.leadingAnchor),
            hostingViewController.view.trailingAnchor.constraint(equalTo: logoView.trailingAnchor),
            hostingViewController.view.bottomAnchor.constraint(equalTo: logoView.bottomAnchor)
        ])
        hostingViewController.didMove(toParent: self)
        logoView.alpha = 0
        let finalStack = UIStackView(arrangedSubviews: [logoView, topStack, UIView.makeDivider(), detailStack])
        finalStack.axis = .vertical
        finalStack.spacing = 20
        finalStack.translatesAutoresizingMaskIntoConstraints = false
        finalStack.layer.shadowColor = UIColor.systemGray6.cgColor
        finalStack.layer.shadowRadius = 3
        finalStack.layer.shadowOpacity = 0.1
        finalStack.layer.cornerRadius = 12
        finalStack.backgroundColor = .systemBackground
        view.addSubview(finalStack)
        NSLayoutConstraint.activate([
            logoView.topAnchor.constraint(equalTo: finalStack.topAnchor,constant: 20),
            finalStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            finalStack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            finalStack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            finalStack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            detailStack.bottomAnchor.constraint(equalTo: finalStack.bottomAnchor, constant: -20)
        ])
        currencyNameLabel.text = viewModel.name
        priceLabel.text = viewModel.currentPrice
        fillDetailsStack()
    }
    
    
    
    func fillDetailsStack() {
        let rankingCell = DetailCellView()
        rankingCell.setupWith(title: "Ranking", value: viewModel.ranking)
        let totalVolumeCell = DetailCellView()
        totalVolumeCell.setupWith(title: "Total Volume", value: viewModel.totalVolume)
        let topStack = UIStackView(arrangedSubviews: [rankingCell, totalVolumeCell])
        topStack.axis = .horizontal
        topStack.distribution = .fillEqually
        detailStack.addArrangedSubview(topStack)
        detailStack.addArrangedSubview(UIView.makeDivider())
        
        let highPriceCell = DetailCellView()
        highPriceCell.setupWith(title: "Highest Price", value: viewModel.highestPrice)
        let lowestPriceCell = DetailCellView()
        lowestPriceCell.setupWith(title: "Lowest Price", value: viewModel.lowestPrice)
        let midStack = UIStackView(arrangedSubviews: [highPriceCell, lowestPriceCell])
        midStack.axis = .horizontal
        midStack.distribution = .fillEqually
        detailStack.addArrangedSubview(midStack)
        detailStack.addArrangedSubview(UIView.makeDivider())
        
        
        let priceChangeCell = DetailCellView()
        priceChangeCell.setupWith(title: "Price change", value: viewModel.priceChange)
        detailStack.addArrangedSubview(priceChangeCell)
        
        let marketCapCell = DetailCellView()
        marketCapCell.setupWith(title: "Market cap", value: viewModel.marketCap)
        let bottomStack = UIStackView(arrangedSubviews: [priceChangeCell, marketCapCell])
        bottomStack.axis = .horizontal
        bottomStack.distribution = .fillEqually
        detailStack.addArrangedSubview(bottomStack)
    }
    
    @objc func closeModal() {
        self.dismiss(animated: true)
    }
}
