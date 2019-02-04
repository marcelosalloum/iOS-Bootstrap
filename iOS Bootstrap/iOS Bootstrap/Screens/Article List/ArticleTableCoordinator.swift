//
//  ArticleTableCoordinator.swift
//  iOS Bootstrap
//
//  Created by Marcelo Salloum dos Santos on 30/01/19.
//  Copyright © 2019 Marcelo Salloum dos Santos. All rights reserved.
//

import UIKit
import EZCoreData

protocol ArticleTableViewControllerDelegate: class {
    func articleTableViewControllerDidSelectArticle(_ selectedArticle: Article)
}

class ArticleTableCoordinator: Coordinator {
    private let presenter: UINavigationController
    private var ezCoreData: EZCoreData!
    private weak var articleTableViewController: ArticleTableViewController?
    private var articleDetailCoordinator: ArticleDetailCoordinator?

    init(presenter: UINavigationController, ezCoreData: EZCoreData) {
        self.presenter = presenter
        self.ezCoreData = ezCoreData
    }

    override func start() {
        // View Controller:
        guard let articleTableViewController = ArticleTableViewController.fromStoryboard("Main") else { return }
        setDeallocallable(with: articleTableViewController)
        articleTableViewController.title = "News"
        articleTableViewController.coordinator = self
        // View Model:
        let viewModel = ArticleTableViewModel()
        articleTableViewController.viewModel = viewModel
        viewModel.delegate = articleTableViewController
        viewModel.ezCoreData = ezCoreData
        // Present View Controller:
        presenter.pushViewController(articleTableViewController, animated: true)
        self.articleTableViewController = articleTableViewController
    }
}

extension ArticleTableCoordinator: ArticleTableViewControllerDelegate {
    func articleTableViewControllerDidSelectArticle(_ selectedArticle: Article) {
        let articleDetailCoordinator = ArticleDetailCoordinator(presenter: presenter, article: selectedArticle)
        articleDetailCoordinator.start()
        articleDetailCoordinator.stop = {
            self.articleDetailCoordinator = nil
        }
        self.articleDetailCoordinator = articleDetailCoordinator
    }
}
