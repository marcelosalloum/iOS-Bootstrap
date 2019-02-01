//
//  Coordinator.swift
//  CKL iOS Challenge
//
//  Created by Marcelo Salloum dos Santos on 30/01/19.
//  Copyright © 2019 Marcelo Salloum dos Santos. All rights reserved.
//

import UIKit


class ApplicationCoordinator: Coordinator {
    let window: UIWindow
    let rootViewController: UINavigationController
    var articleTableCoordinator: ArticleTableCoordinator?
    
    init(window: UIWindow) {
        // Init Values
        self.window = window
        rootViewController = UINavigationController()
        super.init()
        
        // Configures RootVC
        rootViewController.navigationBar.prefersLargeTitles = true
        // Setups ArticleTableCoordinator
        let articleTableCoordinator = ArticleTableCoordinator(presenter: rootViewController)
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
