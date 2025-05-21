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
        let repository = DefaultCryptoRepository(service: dataSource)
        let fetchUseCase = DefaultFetchCurrencyUseCase(repository: repository)
        let searchUseCase = DefaultSearchCurrencyUseCase(repository: repository)
        let viewModel = CCMainListViewModel(fetchUseCase: fetchUseCase, searchUseCase: searchUseCase)
        return CCMainListViewController(viewModel: viewModel)
    }
    
    func makeCurrencyDetailScreen(currency: Currency) -> UIViewController {
        return CurrencyDetailViewController()
    }
}

final class MockedDependencyContainer: DependencyContainer {
    func makeCurrentListScreen(navigationHandler: @escaping (Currency) -> ()) -> UIViewController {
        let dataSource = CryptoServiceStub()
        let repository = DefaultCryptoRepository(service: dataSource)
        let fetchUseCase = DefaultFetchCurrencyUseCase(repository: repository)
        let searchUseCase = DefaultSearchCurrencyUseCase(repository: repository)
        let viewModel = CCMainListViewModel(fetchUseCase: fetchUseCase, searchUseCase: searchUseCase)
        return CCMainListViewController(viewModel: viewModel)
    }
    
    func makeCurrencyDetailScreen(currency: Currency) -> UIViewController {
        return CurrencyDetailViewController()
    }
}
