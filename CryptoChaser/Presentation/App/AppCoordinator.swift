//
//  AppCoordinator.swift
//  CryptoChaser
//
//  Created by Ernesto Sánchez Kuri on 20/05/25.
//

import Foundation
import UIKit

/// A Coordinator that is used to have control of the app's navigation flow
final class AppCoordinator {
    private let window: UIWindow
    // DI container that will help us to build the app with the appropiate repositories, data sourves and use cases
    private let container: DependencyContainer
    private var navigationController: UINavigationController?
    
    init(window: UIWindow, container: DependencyContainer) {
        self.window = window
        self.container = container
    }
    
    /// The initial point of the app. Creates the main list view controller using the dependency container.
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
    
    /// Shows the detail screen for a Currency tabbed in the main screen. It is called from the navigationHandler used in the`makeCurrentListScreen` method.
    /// - Parameter currency: a Currency object that was tapped in the main list.
    private func showDetail(for currency: Currency) {
        let detailViewController = container.makeCurrencyDetailScreen(currency: currency)
        // If ipad show modally
        if (UIDevice().userInterfaceIdiom == .pad ) {
            let detailNavigationVC = UINavigationController(rootViewController: detailViewController)
            navigationController?.present(detailNavigationVC, animated: true)
        } else {
            navigationController?.pushViewController(detailViewController, animated: true)
        }
    }
}
