//
//  DependencyContainer.swift
//  CryptoChaser
//
//  Created by Ernesto Sánchez Kuri on 20/05/25.
//

import Foundation
import UIKit

protocol DependencyContainer {
    func makeCurrentListScreen(navigationHandler: @escaping (Currency) -> ()) -> UIViewController
    func makeCurrencyDetailScreen(currency: Currency) -> UIViewController
}

final class DefaultDependencyContainer: DependencyContainer {
    func makeCurrentListScreen(navigationHandler: @escaping (Currency) -> ()) -> UIViewController {
        let dataSource = RemoteCryptoService()
        let localDataSource = CurrencyCoreDataStorage()
        let repository = DefaultCryptoRepository(service: dataSource, local: localDataSource)
        let viewModel = CryptoListViewModel(repository: repository, navigationHandler: navigationHandler)
        return CryptoListViewController(viewModel: viewModel)
    }
    
    func makeCurrencyDetailScreen(currency: Currency) -> UIViewController {
        let dataSource = RemoteCryptoService()
        let localDataSource = CurrencyCoreDataStorage()
        let repository = DefaultCryptoRepository(service: dataSource, local: localDataSource)
        let viewModel = CurrencyDetailViewModel(currency: currency, repository: repository)
        return CurrencyDetailView.makeCurrencyDetailView(viewModel: viewModel)
    }
}

final class MockedDependencyContainer: DependencyContainer {
    func makeCurrentListScreen(navigationHandler: @escaping (Currency) -> ()) -> UIViewController {
        let repository = MockCryptoRepository()
        let viewModel = CryptoListViewModel(repository: repository, navigationHandler: navigationHandler)
        return CryptoListViewController(viewModel: viewModel)
    }
    
    func makeCurrencyDetailScreen(currency: Currency) -> UIViewController {
        let repository = MockCryptoRepository()
        let viewModel = CurrencyDetailViewModel(currency: currency, repository: repository)
        return CurrencyDetailView.makeCurrencyDetailView(viewModel: viewModel)
    }
}
