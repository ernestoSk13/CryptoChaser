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
        let rootViewController = container.makeCurrentListScreen { currency in
            // TODO: Show Detail Screen
        }
        let navigationController = UINavigationController(rootViewController: rootViewController)
        self.navigationController = navigationController
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
}
