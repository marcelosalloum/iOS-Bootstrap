//
//  ArticleDetailCoordinator.swift
//  iOS Bootstrap
//
//  Created by Marcelo Salloum dos Santos on 30/01/19.
//  Copyright © 2019 Marcelo Salloum dos Santos. All rights reserved.
//

import UIKit
import EZCoreData

class ArticleDetailCoordinator: Coordinator {
    private let presenter: UINavigationController
    private weak var articleDetailViewController: ArticleDetailViewController?
    private var article: Article

    init(presenter: UINavigationController, article: Article) {
        self.presenter = presenter
        self.article = article
    }

    override func start() {
        // View Controller:
        guard let articleDetailViewController = ArticleDetailViewController.fromStoryboard("Main") else { return }
        articleDetailViewController.title = "📚"
        // View Model:
        let viewModel = ArticleDetailViewModel()
        viewModel.article = article
        viewModel.delegate = articleDetailViewController
        articleDetailViewController.viewModel = viewModel
        // Present View Controller:
        presenter.pushViewController(articleDetailViewController, animated: true)
        setDeallocallable(with: articleDetailViewController)
        self.articleDetailViewController = articleDetailViewController
    }
}
