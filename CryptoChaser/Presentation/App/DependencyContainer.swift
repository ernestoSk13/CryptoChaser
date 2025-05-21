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
        let fetchUseCase = DefaultFetchCurrencyUseCase(repository: repository)
        let searchUseCase = DefaultSearchCurrencyUseCase(repository: repository)
        let viewModel = CCMainListViewModel(fetchUseCase: fetchUseCase, searchUseCase: searchUseCase, navigationHandler: navigationHandler)
        return CCMainListViewController(viewModel: viewModel)
    }
    
    func makeCurrencyDetailScreen(currency: Currency) -> UIViewController {
        let viewModel = CurrencyDetailViewModel(currency: currency)
        return CurrencyDetailViewController(viewModel: viewModel)
    }
}

final class MockedDependencyContainer: DependencyContainer {
    func makeCurrentListScreen(navigationHandler: @escaping (Currency) -> ()) -> UIViewController {
        let dataSource = CryptoServiceStub()
        let repository = MockCryptoRepository()
        let fetchUseCase = DefaultFetchCurrencyUseCase(repository: repository)
        let searchUseCase = DefaultSearchCurrencyUseCase(repository: repository)
        let viewModel = CCMainListViewModel(fetchUseCase: fetchUseCase, searchUseCase: searchUseCase, navigationHandler: navigationHandler)
        return CCMainListViewController(viewModel: viewModel)
    }
    
    func makeCurrencyDetailScreen(currency: Currency) -> UIViewController {
        let viewModel = CurrencyDetailViewModel(currency: currency)
        return CurrencyDetailViewController(viewModel: viewModel)
    }
}
