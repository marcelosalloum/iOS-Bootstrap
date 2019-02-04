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
    var articleTableCoordinator: ArticleTableCoordinator?

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
        // Setups ArticleTableCoordinator
        let articleTableCoordinator = ArticleTableCoordinator(presenter: rootViewController, ezCoreData: ezCoreData)
        articleTableCoordinator.start()
        articleTableCoordinator.stop = {
            self.articleTableCoordinator = nil
        }
        self.articleTableCoordinator = articleTableCoordinator
    }

    override func start() {
        window.rootViewController = rootViewController
        window.makeKeyAndVisible()
    }
}
