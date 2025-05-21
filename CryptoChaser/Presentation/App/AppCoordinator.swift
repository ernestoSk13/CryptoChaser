//
//  AppCoordinator.swift
//  CryptoChaser
//
//  Created by Ernesto Sánchez Kuri on 20/05/25.
//

import Foundation
import UIKit

final class AppCoordinator {
    private let window: UIWindow
    // DI container that will help us to build the app with the appropiate repositories, data sourves and use cases
    private let container: DependencyContainer
    private var navigationController: UINavigationController?
    
    init(window: UIWindow, container: DependencyContainer) {
        self.window = window
        self.container = container
    }
    
    func start() {
        let rootViewController = container.makeCurrentListScreen { [weak self] currency in
            // Show Detail Screen
            self?.showDetail(for: currency)
        }
        let navigationController = UINavigationController(rootViewController: rootViewController)
        self.navigationController = navigationController
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
    
    private func showDetail(for currency: Currency) {
        let detailViewController = container.makeCurrencyDetailScreen(currency: currency)
        // If we want to have a navigation detailed view, we can push it with just one line change.
        //navigationController?.pushViewController(detailViewController, animated: true)
        if let sheet = detailViewController.sheetPresentationController {
            sheet.detents = [.medium()]
        }
        navigationController?.present(detailViewController, animated: true)
    }
}
