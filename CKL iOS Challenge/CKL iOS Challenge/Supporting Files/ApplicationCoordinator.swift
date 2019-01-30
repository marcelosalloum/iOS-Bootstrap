//
//  Coordinator.swift
//  CKL iOS Challenge
//
//  Created by Marcelo Salloum dos Santos on 30/01/19.
//  Copyright © 2019 Marcelo Salloum dos Santos. All rights reserved.
//

import Foundation

protocol Coordinator {
    func start()
}


import UIKit

class ApplicationCoordinator: Coordinator {
    let window: UIWindow
    let rootViewController: UINavigationController
    let articleTableCoordinator: ArticleTableCoordinator
    
    init(window: UIWindow) {
        self.window = window
        
        // Setups RootVC
        rootViewController = UINavigationController()
        let articleTableCoordinator = ArticleTableCoordinator(presenter: rootViewController)
        articleTableCoordinator.start()
        self.articleTableCoordinator = articleTableCoordinator
        rootViewController.navigationBar.prefersLargeTitles = true
    }
    
    func start() {  // 6
        window.rootViewController = rootViewController
        window.makeKeyAndVisible()
    }
}



