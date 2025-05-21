//
//  CCMainListViewController.swift
//  CryptoChaser
//
//  Created by Ernesto Sánchez Kuri on 20/05/25.
//

import Foundation
import SwiftUI
import UIKit


final class CCMainListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    private let viewModel: CCMainListViewModel
    private let reuseIdentifier = "CoinCell"
    private let tableView: UITableView = UITableView()
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    private let errorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    init(viewModel: CCMainListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "CryptoChaser"
        setupUI()
        setAccessibility()
        fetchCoins()
    }
    
    
    func setupUI() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(errorView)
        view.addSubview(tableView)
        setupErrorView()
        NSLayoutConstraint.activate([
            errorView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            errorView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            errorView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            errorView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        // Add activity indicator
        view.addSubview(activityIndicator)
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    func setAccessibility() {
        tableView.accessibilityLabel = Constants.Accessibility.MainList.label
        tableView.accessibilityIdentifier = Constants.Accessibility.MainList.identifier
    }
    
    func setupErrorView() {
        let errorScreen = UIHostingController(rootView: MainListErrorView(reloadAction: { [weak self] in
            self?.fetchCoins()
        }))
        errorScreen.view.translatesAutoresizingMaskIntoConstraints = false
        errorView.addSubview(errorScreen.view)
        NSLayoutConstraint.activate([
            errorScreen.view.topAnchor.constraint(equalTo: errorView.topAnchor),
            errorScreen.view.leadingAnchor.constraint(equalTo: errorView.leadingAnchor),
            errorScreen.view.trailingAnchor.constraint(equalTo: errorView.trailingAnchor),
            errorScreen.view.bottomAnchor.constraint(equalTo: errorView.bottomAnchor)
        ])
        errorView.isHidden = true
    }
    
    /// Calls the view model's concurrent function to request the currency list, if the call returns error it shows the error state view with a reload button.
    func fetchCoins() {
        Task {
            activityIndicator.startAnimating()
            do {
                try await viewModel.fetchCoins()
                activityIndicator.stopAnimating()
                errorView.isHidden = true
                tableView.isHidden = false
                tableView.reloadData()
            } catch {
                tableView.isHidden = true
                errorView.isHidden = false
                activityIndicator.stopAnimating()
            }
        }
    }
    
    // MARK: TableView Data Source
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard viewModel.coins.count > 0 else {
            return 10
        }
        
        return viewModel.coins.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        guard viewModel.coins.count > 0 else {
            cell.contentConfiguration = UIHostingConfiguration(content: {
                PlaceholderCell()
            })
            return cell
        }
        
        let currency = viewModel.coins[indexPath.row]
        cell.contentConfiguration = UIHostingConfiguration(content: {
            CurrencyCell(viewModel: CurrencyCellViewModel(currency: currency))
        })
        cell.accessibilityLabel = "\(currency.name)"
        cell.accessibilityValue = "\(currency.currentPrice.formatCurrency())"
        cell.accessibilityIdentifier = Constants.Accessibility.MainList.Row.identifier.replacingOccurrences(of: "$1", with: currency.id)
        
        return cell
    }
    
    // MARK: TableView Delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // TODO: Show detail view
    }
    
}
