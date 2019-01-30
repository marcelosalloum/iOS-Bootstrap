//
//  ArticleDetailCoordinator.swift
//  CKL iOS Challenge
//
//  Created by Marcelo Salloum dos Santos on 30/01/19.
//  Copyright © 2019 Marcelo Salloum dos Santos. All rights reserved.
//

import UIKit


class ArticleDetailCoordinator: Coordinator {
    private let presenter: UINavigationController
    private var articleDetailViewController: ArticleDetailViewController?
    private var article: Article
    
    init(presenter: UINavigationController, article: Article) {
        self.presenter = presenter
        self.article = article
    }
    
    func start() {
        guard let articleDetailViewController = ArticleDetailViewController.fromStoryboard("Main") else { return }
        articleDetailViewController.title = "📚"
        articleDetailViewController.viewModel.article = article
        presenter.pushViewController(articleDetailViewController, animated: true)
        self.articleDetailViewController = articleDetailViewController
    }
}
