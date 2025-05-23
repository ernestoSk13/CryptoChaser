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
    private let emptyCellIdentifier = "EmptyCell"
    private let tableView: UITableView = UITableView()
    private let refreshControl = UIRefreshControl()
    private let searchController: UISearchController = UISearchController(searchResultsController: nil)
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    // DispatchWorkItem to debouncer search
    var searchTask: DispatchWorkItem?
    
    private let errorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var menu: UIMenu {
        let currentSelection = viewModel.sortingOption
        let ascendingOrder = viewModel.ascendingOrder
        
        let ascendingImage = UIImage(systemName: ascendingOrder ? "chevron.up" : "chevron.down")
        let sortByRank = UIAction(title: "Rank", image: currentSelection == .marketCapRank ? ascendingImage : nil) { action in
            self.viewModel.sortCurrencies(.marketCapRank)
            self.tableView.reloadData()
            self.updateMenu()
        }
        
        let sortByName = UIAction(title: "Name", image: currentSelection == .name ? ascendingImage : nil) { action in
            self.viewModel.sortCurrencies(.name)
            self.tableView.reloadData()
            self.updateMenu()
        }
        
        let sortByPrice = UIAction(title: "Price", image: currentSelection == .price ? ascendingImage : nil) { action in
            self.viewModel.sortCurrencies(.price)
            self.tableView.reloadData()
            self.updateMenu()
        }
        
        return UIMenu(title: "", options: [.singleSelection], children: [sortByRank, sortByName, sortByPrice])
    }
    
    
    private let errorSnackbar = SnackbarView()
    
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
        setupSearchController()
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
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: emptyCellIdentifier)
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        refreshControl.tintColor = UIColor.lightGray
        refreshControl.attributedTitle = NSAttributedString(string: "Refreshing...")
        // Add activity indicator
        view.addSubview(activityIndicator)
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        // Add sort button
        let button = UIBarButtonItem(image: UIImage(systemName: "ellipsis.circle"), primaryAction: nil, menu: menu)
        navigationController?.navigationBar.topItem?.rightBarButtonItem = button
    }
    
    func updateMenu() {
        navigationController?.navigationBar.topItem?.rightBarButtonItem?.menu = menu
    }
    
    func setupSearchController() {
        searchController.searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchController.searchBar.placeholder = "Search by Coin Name"
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.searchTextField.accessibilityIdentifier = Constants.Accessibility.MainList.SearchBar.TextField.identifier
        
        navigationController?.navigationBar.barTintColor = .systemBackground
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = true
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
                errorView.isHidden = true
                tableView.isHidden = false
                endRefreshing()
            } catch {
                if viewModel.coins.isEmpty {
                    showErrorScreen()
                } else {
                    presentNetworkErrorSnackbar()
                }
                endRefreshing()
            }
        }
    }
    
    func endRefreshing() {
        activityIndicator.stopAnimating()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            self?.refreshControl.endRefreshing()
        }
        tableView.reloadData()
    }
    
    func presentNetworkErrorSnackbar() {
        errorSnackbar.present(in: view, message: "The network seems to be down. Please try again later.")
    }
    
    func showErrorScreen() {
        tableView.isHidden = true
        errorView.isHidden = false
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
        let identifier = viewModel.coins.count > 0 ? reuseIdentifier : emptyCellIdentifier
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
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
        viewModel.didSelectCurrency(at: indexPath.row)
    }
    
    // MARK: Refresh data
    @objc private func refreshData() {
        fetchCoins()
    }
}

extension CCMainListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchTask?.cancel()
        
        let task = DispatchWorkItem { [weak self] in
            self?.viewModel.searchCurrency(name: searchText)
            self?.tableView.reloadData()
        }
        
        searchTask = task
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: task)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        viewModel.searchCurrency(name: "")
        tableView.reloadData()
    }
}
