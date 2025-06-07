//
//  CryptoListViewController.swift
//  CryptoChaser
//
//  Created by Ernesto Sánchez Kuri on 06/06/25.
//

import Foundation
import UIKit
import Combine

class CryptoListViewController: UIViewController {
    
    private let viewModel: CryptoListViewModel
    private var subscriptions = Set<AnyCancellable>()
    private let reuseIdentifier = "CoinCell"
    private let refreshControl = UIRefreshControl()
    private let searchController: UISearchController = UISearchController(searchResultsController: nil)
    // Content configuration to handle different content states
    var loadingConfig = UIContentUnavailableConfiguration.loading()
    var emptyConfig = UIContentUnavailableConfiguration.empty()
    var noResultsConfig = UIContentUnavailableConfiguration.search()
    
    // UICollectionView Diffable Data Source
    enum Section {
        case main
    }
    typealias DataSource = UICollectionViewDiffableDataSource<Section, Currency>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Currency>

    private lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        flowLayout.minimumLineSpacing = Constants.defaultPadding
        flowLayout.minimumInteritemSpacing = Constants.defaultPadding
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.contentInset = .init(top: 12, left: 12, bottom: 12, right: 12)
        collectionView.register(CurrencyCellView.self, forCellWithReuseIdentifier: CurrencyCellView.identifier)
        collectionView.delegate = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        
        return collectionView
    }()
    
    private lazy var dataSource = makeDataSource()
    
    // DispatchWorkItem to debouncer search
    var searchTask: DispatchWorkItem?
    
    var menu: UIMenu {
        let currentSelection = viewModel.sortingOption
        let ascendingOrder = viewModel.ascendingOrder
        
        let ascendingImage = UIImage(systemName: ascendingOrder ? "chevron.up" : "chevron.down")
        let sortByRank = UIAction(title: "Rank", image: currentSelection == .marketCapRank ? ascendingImage : nil) { action in
            self.viewModel.sortCurrencies(.marketCapRank)
            self.applySnapshot()
            self.updateMenu()
        }
        
        let sortByName = UIAction(title: "Name", image: currentSelection == .name ? ascendingImage : nil) { action in
            self.viewModel.sortCurrencies(.name)
            self.applySnapshot()
            self.updateMenu()
        }
        
        let sortByPrice = UIAction(title: "Price", image: currentSelection == .price ? ascendingImage : nil) { action in
            self.viewModel.sortCurrencies(.price)
            self.applySnapshot()
            self.updateMenu()
        }
        
        return UIMenu(title: "", options: [.singleSelection], children: [sortByRank, sortByName, sortByPrice])
    }
    
    private let errorSnackbar = SnackbarView()
    
    // Animations
    private var hasAnimatedItems = false
    let animationDuration: Double = 1.0
    
    init(viewModel: CryptoListViewModel) {
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
        showLoadingState()
        fetchCoins()
        viewModel.$coins
            .receive(on: DispatchQueue.main)
            .sink { [weak self] currencies in
                if !currencies.isEmpty {
                    self?.endRefreshing()
                }
        }.store(in: &subscriptions)
    }
    
    func setupUI() {
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        // Add sort button
        let button = UIBarButtonItem(image: UIImage(systemName: "ellipsis.circle"), primaryAction: nil, menu: menu)
        navigationController?.navigationBar.topItem?.rightBarButtonItem = button
        // Refresh control
        collectionView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        refreshControl.tintColor = UIColor.lightGray
        refreshControl.attributedTitle = NSAttributedString(string: "Refreshing...")
    }
    
    func setAccessibility() {
        collectionView.accessibilityLabel = Constants.Accessibility.MainList.label
        collectionView.accessibilityIdentifier = Constants.Accessibility.MainList.identifier
    }
    
    func showLoadingState() {
        loadingConfig.text = "Fetching Currencies..."
        loadingConfig.textProperties.font = .boldSystemFont(ofSize: 18)
        self.contentUnavailableConfiguration = loadingConfig
    }
    
    func showEmptyState() {
        emptyConfig.image = UIImage(systemName: "exclamationmark.warninglight")
        emptyConfig.text = "There was an error fetching from the server"
        emptyConfig.secondaryText = "Pull to refresh and try again"
        var retryButton = UIButton.Configuration.borderless()
        retryButton.title = "Try again"
        emptyConfig.button = retryButton
        emptyConfig.buttonProperties.primaryAction = UIAction.init(handler: { _ in
            Task { [weak self] in
                guard let self = self else { return }
                self.fetchCoins()
            }
        })
        
        
        self.contentUnavailableConfiguration = emptyConfig
    }
    
    func showNoResultsState() {
        noResultsConfig.text = "No Results Found"
        guard let searchText = searchController.searchBar.text else { return }
        noResultsConfig.secondaryText = "No results for '\(searchText)'"
        self.contentUnavailableConfiguration = noResultsConfig
    }
    
    /// Calls the view model's concurrent function to request the currency list, if the call returns error it shows the error state view with a reload button.
    func fetchCoins() {
        Task {
            do {
                try await viewModel.fetchCoins()
            } catch {
                if viewModel.coins.isEmpty {
                    showEmptyState()
                } else {
                    presentNetworkErrorSnackbar()
                }
                endRefreshing()
            }
        }
    }
    
    func endRefreshing() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            self?.refreshControl.endRefreshing()
            self?.hasAnimatedItems = true
        }
        applySnapshot()
    }
    
    func updateMenu() {
        navigationController?.navigationBar.topItem?.rightBarButtonItem?.menu = menu
    }
    
    func presentNetworkErrorSnackbar() {
        errorSnackbar.present(in: view, message: "The network seems to be down. Please try again later.")
    }
    
    // MARK: Refresh data
    @objc private func refreshData() {
        fetchCoins()
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
}

extension CryptoListViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    // MARK: Diffable data source
    func makeDataSource() -> DataSource {
        let dataSource = DataSource(collectionView: collectionView) { (collectionView, indexPath, currency) -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CurrencyCellView.identifier, for: indexPath) as? CurrencyCellView
            let currencyViewModel = CurrencyCellViewModel(currency: currency)
            cell?.configure(with: currencyViewModel)
            return cell
        }
        
        return dataSource
    }
    
    func applySnapshot(animatingDifferences: Bool = true) {
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(viewModel.coins)
        if let searchText = searchController.searchBar.text, !searchText.isEmpty, viewModel.coins.isEmpty {
            showNoResultsState()
        } else if !viewModel.coins.isEmpty {
            contentUnavailableConfiguration = nil
        }
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }
    
    //MARK: UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = collectionView.frame.width
        return CGSize(width: size - (Constants.defaultPadding * 2), height: 128)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if !hasAnimatedItems {
            cell.alpha = 0
            UIView.animate(withDuration: 0.3,
                           delay: 0.07 * Double(indexPath.item),
                           options: [.curveEaseInOut]) {
                cell.alpha = 1
            }
        }
    }
    
    // MARK: UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.didSelectCurrency(at: indexPath.row)
    }
}

extension CryptoListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchTask?.cancel()
        
        let task = DispatchWorkItem { [weak self] in
            self?.viewModel.searchCurrency(name: searchText)
            self?.applySnapshot()
        }
        
        searchTask = task
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: task)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        viewModel.searchCurrency(name: "")
        applySnapshot()
    }
}
