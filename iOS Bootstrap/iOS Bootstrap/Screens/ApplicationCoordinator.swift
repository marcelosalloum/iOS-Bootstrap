//
//  Coordinator.swift
//  iOS Bootstrap
//
//  Created by Marcelo Salloum dos Santos on 30/01/19.
//  Copyright © 2019 Marcelo Salloum dos Santos. All rights reserved.
//

import UIKit
import EZCoreData

class ApplicationCoordinator: Coordinator {
    let window: UIWindow
    var ezCoreData: EZCoreData
    let rootViewController: UINavigationController
    var welcomeCoordinator: WelcomeCoordinator?

    init(window: UIWindow) {
        // Init Values
        self.window = window
        rootViewController = UINavigationController()
        ezCoreData = EZCoreData()

        // Offline Handling
        APIHelper.setupReachability()

        super.init()
        // Init Core Data
        ezCoreData.setupPersistence(Constants.databaseName) // Initialize Core Data

        // Configures RootVC
        rootViewController.navigationBar.prefersLargeTitles = true

        // SetUp Welcome Coordinator
        setupWelcomeCoordinator()
//        let isUserLogged = false
//        if !isUserLogged {
//        } else {
//        }
    }

    override func start() {
        window.rootViewController = rootViewController
        window.makeKeyAndVisible()
    }

    fileprivate func setupWelcomeCoordinator() {
        let welcomeCoordinator = WelcomeCoordinator(presenter: rootViewController, ezCoreData: ezCoreData)
        welcomeCoordinator.start()
        welcomeCoordinator.stop = {
            self.welcomeCoordinator = nil
        }
        self.welcomeCoordinator = welcomeCoordinator
    }
}
